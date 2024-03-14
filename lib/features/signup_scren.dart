import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/AuthCubit/auth_states.dart';
import '../bloc/cubit/app_cubit.dart';
import 'loading.dart';

import '../Router.dart';
import '../bloc/AuthCubit/auth_cubit.dart';
import '../models/country_model.dart';
import '../theme/text_style.dart';
import '../widgets/button.dart';
import '../widgets/textFormWidget.dart';
import '../widgets/utils.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fnameController = TextEditingController();

  final TextEditingController lnameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController = TextEditingController();

  final TextEditingController genderController = TextEditingController();

  final TextEditingController ageController = TextEditingController();

  final TextEditingController countryController = TextEditingController();

  final TextEditingController addressbController = TextEditingController();

  String countryCode = "+20";

  List<Country> _countries = Country.getCountries();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit,AuthStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = AuthCubit.get(context);

            return state is SignUpInitialState ? LoadingScreen() : SafeArea(child: Scaffold(
              resizeToAvoidBottomInset: true,
              body: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                        alignment: Alignment.center,
                        child: Container(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "assets/images/fullLogo.png",
                            width: 220.w,
                            height: 100.h,
                          ),
                        ),
                      ),
                      SizedBox(
                          height: 20.h
                      ),
                      Text(
                        'Create your account'.tr(),
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: 15.h
                      ),
                      TextFormGlobal(
                        controller: fnameController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your First Name".tr() : null;
                        },
                        text: 'First Name'.tr(),
                        obscure: false,
                        icon: Icons.person_outline,
                        textInputType: TextInputType.name,
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormGlobal(
                        controller: emailController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your email".tr() : null;
                        },
                        text: 'Email'.tr(),
                        icon: Icons.email_outlined,
                        obscure: false,
                        textInputType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormGlobal(
                        controller: passwordController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your password".tr() : null;
                        },
                        text: 'Password'.tr(),
                        icon: Icons.lock_outline,
                        sufIcon:  IconButton(
                          onPressed: () {
                            cubit.changePasswordVisibility();
                          },
                          icon: Icon(cubit.icon),
                        ),
                        obscure: cubit.isPasswordObscure,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      TextFormGlobal(
                        controller: confirmPasswordController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your confirm password".tr() : null;
                        },
                        text: 'Confirm Password'.tr(),
                        icon: Icons.lock_outline,
                        sufIcon:  IconButton(
                          onPressed: () {
                            cubit.changeConfirmPasswordVisibility();
                          },
                          icon: Icon(cubit.confirmIcon),
                        ),
                        obscure: cubit.isConfirmPasswordObscure,
                        textInputType: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
/*
                      TextFormGlobal(
                        controller: phoneController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your Phone".tr() : null;
                        },
                        text: 'Phone'.tr(),
                        icon: Icons.phone_android,
                        obscure: false,
                        textInputType: TextInputType.number,
                      ),*/
                      TextFormGlobal(
                          controller: phoneController,
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
                          },
                          /*sufIcon: Container(
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
                        height: 10.h,
                      ),
                      TextFormGlobal(
                        controller: lnameController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your address".tr() : null;
                        },
                        text: 'Adress'.tr(),
                        obscure: false,
                        icon: Icons.home_outlined,
                        textInputType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
            /*

                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7,
                              )
                            ]),
                        child: ListTile(
                            leading: Icon(
                              Icons.public,
                              color: Colors.grey,
                            ),
                            title: DropdownButtonHideUnderline(
                              child: DropdownButton<Country>(
                                hint: Text(
                                  cubit.isCountryChanged
                                      ? cubit.country!.name
                                      : "Country",
                                  style: textStyle(context,
                                      size: 14,
                                      fontWeight: FontWeight.w500,
                                      color: cubit.isCountryChanged
                                          ? AppCubit.get(context).primaryColor
                                          : Colors.black54),
                                ),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                ),
                                iconSize: 22,
                                dropdownColor: Colors.white,
                                itemHeight: null,
                                items:
                                cubit.buildDropdownMenuItemsFrom(_countries),
                                onChanged: (value) {
                                  cubit.onChangeDropdownItemFrom(value);
                                },
                              ),
                            )),
                      ),*/
                      SizedBox(
                        height: 10.h,
                      ),
                      /*TextFormGlobal(
                        controller: addressbController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your Invited Code".tr() : null;
                        },
                        text: 'Invited Code'.tr(),
                        icon: Icons.insert_invitation,
                        sufIcon: IconButton(
                          icon: Icon(Icons.info_outlined,color: AppCubit.get(context).primaryColor,),
                          onPressed: (){
                            showDialog(context: context, builder: (context){
                              return  AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                title: Image.asset('assets/images/logo.png'
                                    ,alignment: Alignment.center,fit: BoxFit.contain,height: 120.h),
                                content: Text("Invited Code".tr(),style: textStyle(
                                  context,
                                  size: 20,
                                  fontWeight: FontWeight.w600,
                                ),textAlign: TextAlign.center),
                                actions: [
                                  Column(
                                    children: [
                                      Text(
                                        "Here you can add the invite code for the person who share the app with you".tr(),style:textStyle(
                                        context,

                                      ),textAlign: TextAlign.center
                                        ,),

                                      SizedBox(height: 5.h,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap:()=>Navigator.pop(context),
                                            child: Container(
                                              alignment: Alignment.center,
                                              height:30,
                                              width:80,
                                              child: Text("Ok".tr(),style: textStyle(
                                                context,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,

                                              ),),
                                              decoration:BoxDecoration(
                                                  color:AppCubit.get(context).primaryColor,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              );
                            });
                          },
                        ),
                        obscure: false,
                        textInputType: TextInputType.text,
                      ),*/
                    /*  Container(
                        decoration: BoxDecoration(
                            color: AppCubit.get(context).themeMode == true
                                ? Colors.grey[800]
                                : Colors.white,
                            borderRadius: BorderRadius.circular(6),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 7,
                              )
                            ]),
                        child: ListTile(
                          onTap: //cubit.pickDateDialog(context);
                              () => Utils.showSheet(
                            context,
                            child: buildDatePicker(cubit),
                            onClicked: () {
                              final value = DateFormat('yyyy/MM/dd')
                                  .format(cubit.dateTime!);
                              Utils.showSnackBar(
                                  context, 'Selected "$value"');
                              Navigator.pop(context);
                            },
                          ),
                          leading: Icon(
                            Icons.date_range,
                            color: Colors.grey,
                          ),
                          title: Text(
                            cubit.dateTime == null
                                ? 'Your Birthday'.tr()
                                : '${DateFormat.yMMMd().format(cubit.dateTime!)}',
                            style: textStyle(context,
                                size: 14,
                                fontWeight: FontWeight.w500,
                                color:  AppCubit.get(context).themeMode == true
                                    ? Colors.grey[500]
                                    :Colors.black54),
                          ),
                        ),
                      ),*/
                   /*   SizedBox(
                        height: 10.h,
                      ),
                      TextFormGlobal(
                        controller: addressbController,
                        validator: (value) {
                          return value!.isEmpty ? "Enter your Invite Code".tr() : null;
                        },
                        text: 'Invite Code'.tr(),
                        icon: Icons.insert_invitation,

                        obscure: false,
                        textInputType: TextInputType.text,
                      ),*/
                      SizedBox(
                        height: 10.h,
                      ),
                      ButtonGlobal(
                          title: "Sign Up".tr(),
                          callback: () {

                           if(validateData(context,cubit)){
                              cubit.createEmail(
                                context,
                                  first_name: fnameController.text.trim(),
                                  address: lnameController.text.trim(),
                                  email: emailController.text.trim(),

                                  phone_number: (/*countryCode +*/phoneController.text.trim()).replaceAll('+', '')  ,
                                 // age:DateFormat.yMMMd().format(cubit.dateTime!).toString(),
                                  password: passwordController.text.trim(),
                                  password2: confirmPasswordController.text.trim(),
                              );
                            }
                          }),
                      SizedBox(
                        height: 25.h,
                      ),
                      //SocialLogin(),
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                height: 50,
                color: Colors.transparent,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('You have an account ? '.tr()),
                    InkWell(
                      onTap: (() => Navigator.pushReplacementNamed(
                          context, Routes.loginPage)),
                      child: Text(
                        'Sign In'.tr(),
                        style: textStyle(context,
                            size: 14, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
            ));
          },
      ),
    );
  }

  bool validateData(context,AuthCubit cubit) {
    if (fnameController.text.isEmpty) {
      showToast(
        "first name is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );

      return false;
    }
    else if (lnameController.text.isEmpty) {
      showToast(
        "Last Name is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    }
    else if (emailController.text.isEmpty) {
      showToast(
        "Email is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    }
    else if (passwordController.text.isEmpty) {
      showToast(
        "Password is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    }
    else if (confirmPasswordController.text.isEmpty) {
      showToast(
        "Confirm Password is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    }
    else if (passwordController.text != confirmPasswordController.text) {
      showToast(
        "Password must match!".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    }
    else if (phoneController.text.isEmpty) {
      showToast(
        "Phone is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    }
    else {
      return true;
    }
  }

  Widget buildDatePicker(AuthCubit cubit) => SizedBox(
    height: 180,
    child: CupertinoDatePicker(
      minimumYear: 1950,
      maximumYear: DateTime.now().year,
      initialDateTime: DateTime.now(),
      mode: CupertinoDatePickerMode.date,
      onDateTimeChanged: (dateTime) => cubit.changeOnDateTime(dateTime),
    ),
  );
}
