import 'dart:async';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../core/network/local/DbHelper.dart';
import 'order_screen.dart';

class MapScreen extends StatefulWidget {
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LocationData? _currentPosition;
  LatLng? _latLong;
  bool _locating = false;
  geocoding.Placemark? _placeMark;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(
      31.811191,
      35.2599186,
    ),
    zoom: 25.4746,
  );

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<LocationData> _getLocationPermission() async {
    Location location = Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        log('Service not enabled');
        return Future.error('Service not enabled'.tr());
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      log('_permissionGranted is denied');
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        log('Permission Denied');
        return Future.error('Permission Denied'.tr());
      }
    } else if (_permissionGranted != PermissionStatus.granted) {
      log('Permission not granted');
      return Future.error('Permission Denied'.tr());
    }

    _locationData = await location.getLocation();
    log('_locationData is: ${_locationData.toString()}');
    return _locationData;
  }

  _getUserLocation() async {
    try {
      _currentPosition = await _getLocationPermission();
      log('_currentPosition from _getUserLocation is: ${_currentPosition.toString()}');
      if (_currentPosition != null) {
        log('_currentPosition?.latitude from _getUserLocation is: ${_currentPosition?.latitude.toString()}');
        log('_currentPosition?.longitude from _getUserLocation is: ${_currentPosition?.longitude.toString()}');
        _latLong =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
        _goToCurrentPosition(_latLong!);
        await getUserAddress();
      } else {
        log('_currentPosition from _getUserLocation is: null');
      }
    } catch (e) {
      log('Error getting user location: $e');
    }
  }

  Future<void> getUserAddress() async {
    if (_latLong != null) {
      try {
        List<geocoding.Placemark> placemarks = await geocoding
            .placemarkFromCoordinates(_latLong!.latitude, _latLong!.longitude);
        if (placemarks.isNotEmpty) {
          setState(() {
            _placeMark = placemarks.first;
          });
          log('_placeMark is: ${_placeMark.toString()}');
        }
      } catch (e) {
        log('Error fetching user address: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .75,
                  decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.grey))),
                  child: Stack(
                    children: [
                      GoogleMap(
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapType: _currentMapType ?? MapType.normal,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        onCameraMove: (CameraPosition position) {
                          setState(() {
                            _locating = true;
                            _latLong = position.target;
                          });
                        },
                        buildingsEnabled: true,
                        compassEnabled: true,
                        mapToolbarEnabled: true,
                        zoomGesturesEnabled: true,
                        zoomControlsEnabled: true,
                        onCameraIdle: () {
                          setState(() {
                            _locating = false;
                          });
                          getUserAddress();
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            height: 40.h,
                            width: 160.w,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.sp)))),
                              onPressed: () async {
                                if (_placeMark != null) {
                                  log('_placeMark!.toJson() os: ${_placeMark!.toJson()}');
                                  CacheHelper.saveStringData(
                                      key: 'addresMap',
                                      value: _placeMark!.street! +
                                          ' , ' +
                                          _placeMark!.administrativeArea! +
                                          ' , ' +
                                          _placeMark!.subAdministrativeArea! +
                                          ' , ' +
                                          _placeMark!.locality! +
                                          ', ' +
                                          _placeMark!.subLocality! +
                                          ' , ' +
                                          _placeMark!.thoroughfare! +
                                          ' , ' +
                                          _placeMark!.subThoroughfare!
                                              .toString());
                                  log('CacheHelper.getData(key: \'addresMap\') is: ${CacheHelper.getData(key: 'addresMap')}');
                                  await AppCubit.get(context)
                                      .getCurrentLocation();
                                  log('_currentPosition!.latitude is: ${AppCubit.get(context).latitude}');
                                  log('_currentPosition!.longitude is: ${AppCubit.get(context).longitude}');
                                  CacheHelper.saveStringData(
                                      key: 'langlot',
                                      value:
                                          '${_latLong!.latitude},${_latLong!.longitude}');
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AddOrderScreen()),
                                      (route) => false);
                                } else {
                                  log('PlaceMark is null');
                                }
                              },
                              child: Text('Confirm Location'.tr()),
                            ),
                          ),
                        ),
                      ),
                      Align(alignment: Alignment.topCenter, child: mapType()),
                      Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.location_on,
                            size: 40,
                            color: AppCubit.get(context).primaryColor,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Column(
                    children: [
                      _placeMark != null
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _locating
                                      ? 'Locating...'.tr()
                                      : _placeMark!.locality == null
                                          ? _placeMark!.subLocality!
                                          : _placeMark!.locality!,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      _placeMark!.subLocality!,
                                    ),
                                    Text(_placeMark!.subAdministrativeArea !=
                                            null
                                        ? '${_placeMark!.subAdministrativeArea!}, '
                                        : ''),
                                  ],
                                ),
                                Text(
                                    '${_placeMark!.administrativeArea!}, ${_placeMark!.country!}, ${_placeMark!.postalCode!}')
                              ],
                            )
                          : Container(),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _goToCurrentPosition(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(latlng.latitude, latlng.longitude),
        zoom: 14.4746)));
  }

  MapType? _currentMapType;
  Widget mapType() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 10),
      child: Container(
        color: AppCubit.get(context).primaryColor,
        height: 25.h,
        width: 90.w,
        alignment: Alignment.center,
        child: DropdownButton<MapType>(
          value: _currentMapType,
          items: <DropdownMenuItem<MapType>>[
            DropdownMenuItem<MapType>(
              value: MapType.normal,
              child: Text('Normal'.tr()),
            ),
            DropdownMenuItem<MapType>(
              value: MapType.satellite,
              child: Text('Satellite'.tr()),
            ),
            DropdownMenuItem<MapType>(
              value: MapType.terrain,
              child: Text('Terrain'.tr()),
            ),
            DropdownMenuItem<MapType>(
              value: MapType.hybrid,
              child: Text('Hybrid'.tr()),
            ),
          ],
          onChanged: (MapType? newValue) {
            setState(() {
              _currentMapType = newValue;
            });
          },
        ),
      ),
    );
  }
}
