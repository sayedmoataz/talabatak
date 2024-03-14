import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/cubit/app_cubit.dart';
import '../../bloc/cubit/app_states.dart';
import '../../core/network/local/DbHelper.dart';
import '../../models/vendor_model.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/default_cached_network_image.dart';
import '../../widgets/shoppage_skeleton.dart';
import '../CategoryScreen/category_screen.dart';
import '../layout/bottomNavigation_layout.dart';
import '../search_screen.dart';
import 'shop_details_screen.dart';

class ShopsScreen extends StatelessWidget {
  const ShopsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getVendors(context)
        ..getSlider()
        ..getCategories()
        ,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is SuccesGetDataStates) {
            AppCubit.get(context).getArea(context,
                screen: CacheHelper.getData(key: 'CityId') != null);
          }
        },
        builder: (context, state) {
          Size size = MediaQuery.of(context).size;
          AppCubit cubit = BlocProvider.of(context);
          return (cubit.categoryModel == null ||
                  cubit.sliderModel == null ||
                  cubit.vendorModel == null)
              ? SkeletonHorizon2()
              : Scaffold(
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SearchScreen()));
                                },
                                child: Card(
                                  elevation: 1,
                                  color: AppCubit.get(context).themeMode == true
                                      ? Colors.grey[800]
                                      : Colors.white,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.search),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            "Search...".tr(),
                                            style: textStyle(context,
                                                size: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.grey),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: CarouselSlider(
                                options: CarouselOptions(
                                  onPageChanged: (index, reason) {
                                    cubit.changeSliderIndex(index);
                                  },
                                  autoPlay: true,
                                  aspectRatio: 2.2,
                                  viewportFraction: 0.9,
                                  enlargeCenterPage: true,
                                ),
                                items: List.generate(
                                  cubit.sliderModel!.results!.length,
                                  (int index) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: DefaultCachedNetworkImage(
                                          imageUrl: cubit.sliderModel!
                                              .results![index].image!,
                                          fit: BoxFit.fill,
                                        ),
                                        // Image.network(
                                        //   cubit.sliderModel!.results![index]
                                        //       .image!,
                                        //   fit: BoxFit.contain,
                                        //   width:
                                        //       MediaQuery.of(context).size.width,
                                        //   errorBuilder: (BuildContext context,
                                        //       Object exception,
                                        //       StackTrace? stackTrace) {
                                        //     return Image.network(
                                        //         "https://i.imgur.com/kBOeCoM.png");
                                        //   },
                                        //   loadingBuilder: (BuildContext context,
                                        //       Widget child,
                                        //       ImageChunkEvent?
                                        //           loadingProgress) {
                                        //     if (loadingProgress == null)
                                        //       return child;
                                        //     return Center(
                                        //       child: CircularProgressIndicator(
                                        //         value: loadingProgress
                                        //                     .expectedTotalBytes !=
                                        //                 null
                                        //             ? loadingProgress
                                        //                     .cumulativeBytesLoaded /
                                        //                 loadingProgress
                                        //                     .expectedTotalBytes!
                                        //             : null,
                                        //       ),
                                        //     );
                                        //   },
                                        // ),
                                      )),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: cubit.sliderModel!.results!.map((url) {
                                int index =
                                    cubit.sliderModel!.results!.indexOf(url);
                                return Container(
                                  width: 30.0,
                                  height: 3.0,
                                  margin: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 2.0),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    color: cubit.sliderIndex == index
                                        ? cubit.primaryColor
                                        : Colors.grey,
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 60,
                              child: ListView.separated(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  physics: const ScrollPhysics(),
                                  itemBuilder: (context, index) => cubit
                                              .categoryModel!
                                              .results![index]
                                              .name ==
                                          'اضافات'
                                      ? Container()
                                      : InkWell(
                                          onTap: () {
                                            CacheHelper.saveIntData(
                                                    key: 'catInt',
                                                    value: cubit.categoryModel!
                                                        .results![index].id)
                                                .then((value) => {
                                                      CacheHelper.saveIntData(
                                                              key: 'homePath',
                                                              value: 1)
                                                          .then((value) => {
                                                                CacheHelper.saveIntData(
                                                                    key:
                                                                        'catId',
                                                                    value: cubit
                                                                        .categoryModel!
                                                                        .results![
                                                                            index]
                                                                        .id),
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                CategoryScreen()))
                                                              })
                                                    });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Container(
                                              width: 110,
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                              ),
                                              child: Stack(
                                                children: [
                                                  DefaultCachedNetworkImage(
                                                    imageUrl: cubit
                                                        .categoryModel!
                                                        .results![index]
                                                        .image!,
                                                    fit: BoxFit.cover,
                                                    width: 300,
                                                  ),
                                                  // Image.network(
                                                  //   cubit.categoryModel!
                                                  //       .results![index].image!,
                                                  //   width: 300,
                                                  //   fit: BoxFit.cover,
                                                  //   loadingBuilder: (BuildContext
                                                  //           context,
                                                  //       Widget child,
                                                  //       ImageChunkEvent?
                                                  //           loadingProgress) {
                                                  //     if (loadingProgress ==
                                                  //         null) return child;
                                                  //     return Center(
                                                  //       child:
                                                  //           CircularProgressIndicator(
                                                  //         value: loadingProgress
                                                  //                     .expectedTotalBytes !=
                                                  //                 null
                                                  //             ? loadingProgress
                                                  //                     .cumulativeBytesLoaded /
                                                  //                 loadingProgress
                                                  //                     .expectedTotalBytes!
                                                  //             : null,
                                                  //       ),
                                                  //     );
                                                  //   },
                                                  // ),
                                                  Positioned(
                                                    bottom: 0,
                                                    child: Container(
                                                      height: 27,
                                                      width: 110,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey[400]!
                                                            .withOpacity(0.6),
                                                      ),
                                                      child: Text(
                                                        cubit
                                                            .categoryModel!
                                                            .results![index]
                                                            .name!,
                                                        style: textStyle(
                                                            context,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.black87),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 0,
                                      ),
                                  itemCount:
                                      cubit.categoryModel!.results!.length),
                            ),
                            InkWell(
                              onTap: () {
                                cubit.changeGrid();
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0.h),
                                child: Card(
                                  elevation: 1,
                                  color: cubit.primaryColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                      width: 200.w,
                                      height: 40.h,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Icon(
                                            Icons.change_circle_outlined,
                                            color: Colors.white,
                                          ),
                                          Text(
                                            'Change Design'.tr(),
                                            style: textStyle(context,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                size: 16.sp),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            cubit.gridView == 0
                                ? AnimatedSwitcher(
                                    key: ValueKey<int>(14),
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return FadeTransition(
                                          child: child, opacity: animation);
                                    },
                                    child: GridView.builder(
                                      itemCount: cubit.vendorModel!.count!,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisExtent: 160,
                                        childAspectRatio: 1,
                                        mainAxisSpacing: 22,
                                      ),
                                      itemBuilder: (context, index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: InkWell(
                                          child: Card(
                                            elevation: 1,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Column(
                                              children: [
                                                Stack(
                                                  children: [
                                                    cubit
                                                                .vendorModel!
                                                                .results![index]
                                                                .freeDeliveryLimit ==
                                                            null
                                                        ? Container()
                                                        : Container(
                                                            alignment: Alignment
                                                                .topCenter,
                                                            height: 25.h,
                                                            decoration:
                                                                BoxDecoration(
                                                                    color: cubit
                                                                        .primaryColor,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(
                                                                      topRight:
                                                                          Radius.circular(
                                                                              15),
                                                                      topLeft: Radius
                                                                          .circular(
                                                                              15),
                                                                    )),
                                                            child: Text(
                                                              'شحن مجاني للطلبات فوق ${cubit.vendorModel!.results![index].freeDeliveryLimit}',
                                                              style: textStyle(
                                                                  context,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  size: 10.sp),
                                                            ),
                                                          ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          top: cubit
                                                                      .vendorModel!
                                                                      .results![
                                                                          index]
                                                                      .freeDeliveryLimit ==
                                                                  null
                                                              ? 0
                                                              : 20.0.h),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                        child:
                                                            DefaultCachedNetworkImage(
                                                          imageUrl: cubit
                                                                  .vendorModel!
                                                                  .results![
                                                                      index]
                                                                  .image ??
                                                              'https://i.imgur.com/7vHILrC.jpeg',
                                                          fit: BoxFit.cover,
                                                          height: cubit
                                                                      .vendorModel!
                                                                      .results![
                                                                          index]
                                                                      .freeDeliveryLimit ==
                                                                  null
                                                              ? 90.h
                                                              : 70.h,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width,
                                                        ),
                                                        //  Image.network(
                                                        //   cubit
                                                        //           .vendorModel!
                                                        //           .results![
                                                        //               index]
                                                        //           .image ??
                                                        //       'https://i.imgur.com/7vHILrC.jpeg',
                                                        //   fit: BoxFit.cover,
                                                        //   height: cubit
                                                        //               .vendorModel!
                                                        //               .results![
                                                        //                   index]
                                                        //               .freeDeliveryLimit ==
                                                        //           null
                                                        //       ? 90.h
                                                        //       : 70.h,
                                                        //   width:
                                                        //       MediaQuery.of(
                                                        //               context)
                                                        //           .size
                                                        //           .width,
                                                        //   loadingBuilder:
                                                        //       (BuildContext
                                                        //               context,
                                                        //           Widget
                                                        //               child,
                                                        //           ImageChunkEvent?
                                                        //               loadingProgress) {
                                                        //     if (loadingProgress ==
                                                        //         null)
                                                        //       return child;
                                                        //     return Center(
                                                        //       child:
                                                        //           CircularProgressIndicator(
                                                        //         value: loadingProgress
                                                        //                     .expectedTotalBytes !=
                                                        //                 null
                                                        //             ? loadingProgress
                                                        //                     .cumulativeBytesLoaded /
                                                        //                 loadingProgress
                                                        //                     .expectedTotalBytes!
                                                        //             : null,
                                                        //       ),
                                                        //     );
                                                        //   },
                                                        // )
                                                      ),
                                                    ),
                                                    Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Padding(
                                                          padding: EdgeInsets.only(
                                                              top: cubit
                                                                          .vendorModel!
                                                                          .results![
                                                                              index]
                                                                          .freeDeliveryLimit ==
                                                                      null
                                                                  ? 5
                                                                  : 45,
                                                              right: 5),
                                                          child: Container(
                                                            height: 40,
                                                            width: 40,
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .withOpacity(
                                                                        0.8),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            25)),
                                                            child: IconButton(
                                                              onPressed: () {
                                                                CacheHelper.getData(
                                                                            key:
                                                                                "isLogged") ==
                                                                        false
                                                                    ? popDialog(
                                                                        context:
                                                                            context,
                                                                        title: 'Login First'
                                                                            .tr(),
                                                                        content:
                                                                            'Please Sign In First'
                                                                                .tr(),
                                                                        boxColor:
                                                                            Colors
                                                                                .red)
                                                                    : AppCubit.get(context).LikeShop(
                                                                        cubit
                                                                            .vendorModel!
                                                                            .results![index]
                                                                            .id!,
                                                                        context);
                                                              },
                                                              icon: Icon(CacheHelper.getData(
                                                                          key:
                                                                              "vendorLiked${cubit.vendorModel!.results![index].id!}") ==
                                                                      true
                                                                  ? Icons
                                                                      .favorite
                                                                  : Icons
                                                                      .favorite_border),
                                                            ),
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                                Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 2.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        Text(
                                                            cubit
                                                                        .vendorModel!
                                                                        .results![
                                                                            index]
                                                                        .name!
                                                                        .length >
                                                                    15
                                                                ? cubit
                                                                        .vendorModel!
                                                                        .results![
                                                                            index]
                                                                        .name!
                                                                        .substring(
                                                                            0,
                                                                            14) +
                                                                    "..."
                                                                : cubit
                                                                    .vendorModel!
                                                                    .results![
                                                                        index]
                                                                    .name!,
                                                            style: textStyle(
                                                                context,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                size: 11)),
                                                        Text(
                                                          cubit
                                                                      .vendorModel!
                                                                      .results![
                                                                          index]
                                                                      .status ==
                                                                  'open'
                                                              ? 'open'.tr()
                                                              : 'close'.tr(),
                                                          style: textStyle(
                                                              context,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              size: 8.sp,
                                                              color: cubit
                                                                          .vendorModel!
                                                                          .results![
                                                                              index]
                                                                          .status ==
                                                                      'open'
                                                                  ? AppCubit.get(
                                                                          context)
                                                                      .primaryColor
                                                                  : cubit.vendorModel!.results![index].status ==
                                                                          'close'
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .amber),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ),
                                          onTap: () {
                                            vendorCondition(
                                                cubit.vendorModel!
                                                    .results![index],
                                                context);
                                          },
                                        ),
                                      ),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                    ),
                                  )
                                : AnimatedSwitcher(
                                    key: ValueKey<int>(14),
                                    duration: const Duration(milliseconds: 200),
                                    transitionBuilder: (Widget child,
                                        Animation<double> animation) {
                                      return FadeTransition(
                                          child: child, opacity: animation);
                                    },
                                    child: ListView.separated(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, index) =>
                                            buildShopsScreen(
                                                context: context,
                                                vendors: cubit.vendorModel!
                                                    .results![index]),
                                        separatorBuilder: (context, index) =>
                                            const SizedBox(
                                              height: 0,
                                            ),
                                        itemCount:
                                            cubit.vendorModel!.results!.length),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

vendorCondition(vendors, context) {
  if (vendors.status == 'close') {
    popDialog(
        context: context,
        title: 'Shop is close now'.tr(),
        content: 'come another time'.tr(),
        boxColor: AppCubit.get(context).primaryColor);
  } else if (vendors.status == 'soon') {
    popDialog(
        context: context,
        title: 'We still add products'.tr(),
        content: 'come another time'.tr(),
        boxColor: AppCubit.get(context).primaryColor);
  } else if (vendors.status == 'busy') {
    popDialog(
        context: context,
        title: 'Shop is so busy'.tr(),
        content: 'come another time'.tr(),
        boxColor: AppCubit.get(context).primaryColor);
  } else {
    String? cityPrice;

    for (int i = 0; i <= vendors.areas!.length - 1; i++) {
      if (CacheHelper.getData(key: 'CityName') == vendors.areas![i].name) {
        cityPrice = vendors.areas![i].deliveryCost!.cost!;
        print(cityPrice.toString());
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShopDetailsScreen(
                      cityPrice: cityPrice!,
                      vendorId: vendors.id!,
                      results: vendors,
                    )));
      } else {
        print('nn');
      }
    }
    /*
*/
  }
}

Widget buildShopsScreen({
  required BuildContext context,
  required Vendors vendors,
}) =>
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {
          vendorCondition(vendors, context);
        },
        child: Container(
          height: 62,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 0.6,
                blurRadius: 0.6,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(
                          vendors.image ?? 'https://i.imgur.com/7vHILrC.jpeg'),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      vendors.name!,
                      style: textStyle(context,
                          fontWeight: FontWeight.bold, size: 18.sp),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      vendors.status == 'open' ? 'open'.tr() : 'close'.tr(),
                      style: textStyle(context,
                          fontWeight: FontWeight.bold,
                          size: 8.sp,
                          color: vendors.status == 'open'
                              ? AppCubit.get(context).primaryColor
                              : vendors.status == 'close'
                                  ? Colors.red
                                  : Colors.amber),
                    ),
                    IconButton(
                      icon: Icon(CacheHelper.getData(
                                  key: "vendorLiked${vendors.id!}") ==
                              true
                          ? Icons.favorite
                          : Icons.favorite_border),
                      onPressed: () {
                        CacheHelper.getData(key: "isLogged") == false
                            ? popDialog(
                                context: context,
                                title: 'Login First'.tr(),
                                content: 'Please Sign In First'.tr(),
                                boxColor: Colors.red)
                            : AppCubit.get(context)
                                .LikeShop(vendors.id!, context);
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
