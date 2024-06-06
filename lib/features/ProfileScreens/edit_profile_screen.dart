import 'dart:io';

import 'package:clay_containers/widgets/clay_container.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_tag_editor/tag_editor.dart';
import '../../Router.dart';
import '../../bloc/AuthCubit/auth_cubit.dart';
import '../../bloc/AuthCubit/auth_states.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../loading.dart';
import '../../models/country_model.dart';
import '../../widgets/button.dart';

import '../../widgets/textFormWidget.dart';
import '../login_screen.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  var fnameController = TextEditingController();

  var lnameController = TextEditingController();

  var bioController = TextEditingController();

  var addressController = TextEditingController();

  var ageController = TextEditingController();

  var phoneController = TextEditingController();


  List<Country> _countries = Country.getCountries();

  final TextEditingController tagsController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit()..getUserData(),
      child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {
          if(state is UploadProfileImageLoadingState ){
            LoadingScreen();
          }
        },
        builder: (context, state) {
          AuthCubit cubit = AuthCubit.get(context);

          var userModel = cubit.userModel;



          return userModel == null ? LoadingScreen(): Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      const SafeArea(
                        child: SizedBox.shrink(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () => Navigator.pop(context),
                            child: Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              margin: EdgeInsets.all(12),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.arrow_back_ios_new_outlined),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              "Edit Profile".tr(),
                              style: GoogleFonts.poppins(
                                color: AppCubit.get(context).primaryColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 20.sp,
                              ),
                            ),
                          ),
                        ],
                      ),

                      Container(
                        height: 120.0.h,
                        child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [

                              Stack(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(100),
                                        child: cubit.selectedImagePath == ''
                                            ? Image(
                                                image: NetworkImage(
                                                    cubit.userModel!.image ?? "https://i.imgur.com/7vHILrC.jpeg"))
                                            : Image.file(
                                                File(cubit.selectedImagePath),
                                              ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cubit.imageNum = 1;

                                        selectImage(cubit, context);
                                      },
                                      icon: CircleAvatar(
                                        radius: 20.0,
                                        child: Icon(
                                          Icons.camera,
                                          size: 18.0,
                                        ),
                                      ),
                                    ),
                                  ]),
                            ]),
                      ),
                      SizedBox(height: 20,),

                      SizedBox(
                        height: 25.0.h,
                      ),

                      TextFormGlobal(
                        initalval: userModel.name,
                        onChange: (val){
                          fnameController.text = val;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter your First Name".tr() : null;
                        },
                        text: 'First Name'.tr(),
                        obscure: false,
                        icon: Icons.person_outline,
                        textInputType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 15.0.h,
                      ),
                      TextFormGlobal(
                        initalval: userModel.address,
                        onChange: (val){
                          lnameController.text = val;
                        },
                        validator: (value) {
                          return value!.isEmpty ? "Enter your address".tr() : null;
                        },
                        text: 'Adress'.tr(),
                        obscure: false,
                        icon: Icons.home_outlined,
                        textInputType: TextInputType.name,
                      ),

                      SizedBox(
                        height: 15.0.h,
                      ),
                      TextFormGlobal(
                          initalval: userModel.phone,

                          validator: (value) {
                            return value!.isEmpty
                                ? "Enter your phone".tr()
                                : null;
                          },
                          icon: Icons.phone_android,
                          text: 'Phone'.tr(),
                          textInputType: TextInputType.phone,
                          onChange: (val){
                            print((countryCode +val).replaceAll('+', ''));
                            phoneController.text = val;

                          },
                         /* sufIcon: Container(
                            width: 130,
                            height: 50,
                            child: CountryCodePicker(
                              backgroundColor:AppCubit.get(context).themeMode == true ?  Colors.grey[800]: Colors.grey,
                              dialogBackgroundColor: AppCubit.get(context).themeMode == true ?  Colors.grey[800]:Colors.white,
                              barrierColor: Colors.transparent,                              onChanged: (country) {
                              print(country.dialCode);
                              countryCode = country.dialCode!;
                              print(countryCode +phoneController.text);

                            },
                              initialSelection: 'SD',
                              favorite: ['+249', 'SD'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              onInit: (code) =>
                              countryCode = code!.dialCode!,
                            ),
                          ),*/
                          obscure: false),

                      SizedBox(
                        height: 15.0.h,
                      ),

                      ButtonGlobal(
                          title: "Update".tr(),
                          callback: () {
                            cubit.updateProfile(context,
                            image: cubit.selectedImagePath,
                            cover: cubit.selectedCoverPath,
                            first_name: fnameController.text.isNotEmpty ? fnameController.text : userModel.name,
                            last_name: lnameController.text.isNotEmpty ? lnameController.text : userModel.address,
                            bio: bioController.text,
                            address: addressController.text,
                            age: ageController.text,
                            phone_number:phoneController.text.isNotEmpty ? (countryCode +phoneController.text.trim()).replaceAll('+', ''): userModel.phone,

                            );
                          }),
                      SizedBox(
                        height: 20.0.h,
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

  Future selectImage(AuthCubit cubit, context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: SizedBox(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Select Image From !'.tr(),
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if(cubit.imageNum == 2){
                              cubit.selectedCoverPath =
                              await cubit.selectImageFromGallery();
                              if (cubit.selectedCoverPath != '') {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                //setState(() {});
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                  content: Text("No Image Selected !".tr()),
                                ));
                              }
                            }
                            if(cubit.imageNum == 1){
                              cubit.selectedImagePath =
                              await cubit.selectImageFromGallery();
                              if (cubit.selectedImagePath != '') {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                //setState(() {});
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                  content: Text("No Image Selected !".tr()),
                                ));
                              }
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/gallery.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                     Text('Gallery'.tr()),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if(cubit.imageNum == 1){
                              cubit.selectedImagePath =
                              await cubit.selectImageFromCamera();
                              if (cubit.selectedImagePath != '') {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                //setState(() {});
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                  content: Text("No Image Selected !".tr()),
                                ));
                              }
                            }
                            if(cubit.imageNum == 2){
                              cubit.selectedCoverPath =
                              await cubit.selectImageFromCamera();
                              if (cubit.selectedCoverPath != '') {
                                // ignore: use_build_context_synchronously
                                Navigator.pop(context);
                                //setState(() {});
                              } else {
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context)
                                    .showSnackBar( SnackBar(
                                  content: Text("No Image Selected !".tr()),
                                ));
                              }
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/images/camera.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                     Text('Camera'.tr()),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
