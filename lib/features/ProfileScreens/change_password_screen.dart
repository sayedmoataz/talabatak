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

import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/textFormWidget.dart';

class ChangePassword extends StatefulWidget {
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  var oldPassController = TextEditingController();

  var newPassController = TextEditingController();

  var conPassController = TextEditingController();

  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthStates>(
      listener: (context, state) {
        if(state is UploadProfileImageLoadingState ){
          LoadingScreen();
        }
      },
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);

        var userModel = cubit.userModel;



        return cubit.userModel == null ? LoadingScreen(): Scaffold(
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
                            "Change Password".tr(),
                            style: GoogleFonts.poppins(
                              color: AppCubit.get(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20,),

                    SizedBox(
                      height: 125.0.h,
                    ),

                    TextFormGlobal(
                      controller: oldPassController,
                      validator: (value) {
                        return value!.isEmpty ? "Enter your password".tr() : null;
                      },
                      text: 'Old Password'.tr(),
                      icon: Icons.lock_clock_outlined,
                      sufIcon: IconButton(
                        onPressed: () {
                          cubit.changePasswordVisibility();
                        },
                        icon: Icon(cubit.icon),
                      ),
                      obscure: cubit.isPasswordObscure,
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    TextFormGlobal(
                      controller: newPassController,
                      validator: (value) {
                        return value!.isEmpty ? "Enter your New password".tr() : null;
                      },
                      text: 'New Password'.tr(),
                      icon: Icons.lock_outline,
                      sufIcon: IconButton(
                        onPressed: () {
                          cubit.changePasswordVisibility();
                        },
                        icon: Icon(cubit.icon),
                      ),
                      obscure: cubit.isPasswordObscure,
                      textInputType: TextInputType.text,
                    ),
                    SizedBox(
                      height: 15.0.h,
                    ),
                    TextFormGlobal(
                      controller: conPassController,
                      validator: (value) {
                        return value!.isEmpty ? "Confirm New password".tr() : null;
                      },
                      text: 'Confirm New Password'.tr(),
                      icon: Icons.lock,
                      sufIcon: IconButton(
                        onPressed: () {
                          cubit.changePasswordVisibility();
                        },
                        icon: Icon(cubit.icon),
                      ),
                      obscure: cubit.isPasswordObscure,
                      textInputType: TextInputType.text,
                    ),

                    SizedBox(
                      height: 15.0.h,
                    ),

                    ButtonGlobal(
                        title: "Update".tr(),
                        callback: () {
                          if(conPassController.text.isNotEmpty || newPassController.text.isNotEmpty || oldPassController.text.isNotEmpty){
                            if(conPassController.text == newPassController.text){
                              cubit.changePassword(context,
                              newPass: newPassController.text,
                              confPass: conPassController.text,
                              oldPass: oldPassController.text);
                            }else {
                              popDialog(
                                  context: context,
                                  title: 'Check Again'.tr(),
                                  content: 'Be Sure that password is match'.tr(),
                                  boxColor: Colors.red
                              );
                            }
                          }else {
                            popDialog(
                                context: context,
                                title: 'Please Fill all fields'.tr(),
                                content: 'Dont keep any field empty'.tr(),
                                boxColor: Colors.red
                            );
                          }

                        /*  cubit.updateProfile(context,
                          image: cubit.selectedImagePath,
                          cover: cubit.selectedCoverPath,
                          first_name: fnameController.text,
                          last_name: lnameController.text,
                          bio: bioController.text,
                          address: addressController.text,
                          age: ageController.text,
                          country: cubit.isCountryChanged ? cubit.country!.name : userModel!.country!,
                          phone_number: phoneController.text,

                          );*/
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
