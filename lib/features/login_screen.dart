import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import '../bloc/AuthCubit/auth_states.dart';
import '../bloc/cubit/app_cubit.dart';
import '../theme/text_style.dart';
import '../widgets/loading.dart';

import '../Router.dart';

import '../bloc/AuthCubit/auth_cubit.dart';
import '../core/network/local/DbHelper.dart';
import '../widgets/button.dart';
import '../widgets/custom_listTile.dart';
import '../widgets/textFormWidget.dart';
String countryCode = "+20";

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(),
      child: BlocConsumer<AuthCubit,AuthStates>(
          listener: (context, state) {
        /*  if (state is LogInSuccessState)
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.homeScreen, (route) => false);*/
        }, builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);

          return /*state is LogInInitialState
              ? LoadingScreen()
              : */Scaffold(
                  body: SingleChildScrollView(
                    child: SafeArea(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          /*  InkWell(
                              onTap:  (){
                                showDialog(context: context, builder: (context){
                                  return  AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15)
                                    ),
                                    title: Image.asset('assets/gifs/about.gif'
                                        ,alignment: Alignment.center,fit: BoxFit.contain,height: 120.h),
                                    content: Text("Change Language".tr(),style: textStyle(
                                      context,
                                      size: 20,
                                      fontWeight: FontWeight.w600,
                                    ),textAlign: TextAlign.center),
                                    actions: [
                                      Column(
                                        children: [
                                          Text(
                                            "What Language do you prefer ?".tr(),style:textStyle(
                                            context,

                                          ),textAlign: TextAlign.center
                                            ,),

                                          SizedBox(height: 5.h,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [

                                              InkWell(
                                                onTap:(){
                                                  AppCubit.get(context).changeAppLanguage('en');
                                                  EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height:30,
                                                  width:80,
                                                  child: Text("English".tr(),style: textStyle(
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
                                              InkWell(
                                                onTap:() {
                                                  AppCubit.get(context).changeAppLanguage('ar');
                                                  EasyLocalization.of(context)!.setLocale(Locale('ar','IQ'));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height:30,
                                                  width:80,
                                                  child: Text("العربيه".tr(),style: textStyle(
                                                    context,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,

                                                  ),),
                                                  decoration:BoxDecoration(
                                                      color:Colors.red,
                                                      borderRadius: BorderRadius.circular(10)
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap:() {
                                                  AppCubit.get(context).changeAppLanguage('tr');
                                                  EasyLocalization.of(context)!.setLocale(Locale('tr','TR'));
                                                },
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  height:30,
                                                  width:80,
                                                  child: Text("Français".tr(),style: textStyle(
                                                    context,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,

                                                  ),),
                                                  decoration:BoxDecoration(
                                                      color:Colors.green,
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
                              child: Text('Change Language'.tr(),
                              style: textStyle(context,size: 16.sp,fontWeight: FontWeight.bold)),
                            ),*/
                            Align(
                              alignment: Alignment.topRight,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  top: 44,
                                  right: 15,
                                ),
                                child: Container(
                                  width: 71,
                                  height: 43,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800]!.withOpacity(0.7),
                                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                                  ),
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(context, Routes.homeScreen);
                                      },
                                      child: Text(
                                        "Guest".tr(),
                                        style: textStyle(context,color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            Container(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  "assets/images/fullLogo.png",
                                  width: 150.w,
                                  height: 120.h,
                                )),
                            const SizedBox(height: 50),
                            Text('Login to your account'.tr(),
                                style: textStyle(context,
                                    size: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(
                              height: 15,
                            ),
                            TextFormGlobal(
                                controller: emailController,
                                validator: (value) {
                                  return value!.isEmpty ? cubit.changeSign ==false  ?"Enter your Email".tr() :"Enter your Phone".tr() : null;

                                },
                                icon: Icons.key,
                                text:cubit.changeSign ==false  ?'Enter your Email'.tr() :'Enter your Phone'.tr(),
                                onChange: (val){
                                  print((countryCode +val).replaceAll('+', ''));
                                },
                         /*       sufIcon:cubit.changeSign ==false ?Container(height: 0,width: 0,) :  Container(
                                  width: 110,
                                  height: 50,
                                  child: CountryCodePicker(
                                    backgroundColor:AppCubit.get(context).themeMode == true ?  Colors.grey[800]: Colors.grey,
                                   dialogBackgroundColor: AppCubit.get(context).themeMode == true ?  Colors.grey[800]:Colors.white,
                                    barrierColor: Colors.transparent,
                                    onChanged: (country) {
                                      print(country.dialCode);
                                      countryCode = country.dialCode!;
                                      print(countryCode +emailController.text);

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
                                obscure: false, textInputType: TextInputType.emailAddress,),

                            const SizedBox(
                              height: 20,
                            ),

                            // Password Input field
                            TextFormGlobal(
                                controller: passwordController,
                                validator: (value) {
                                  return value!.isEmpty
                                      ? "Enter your Password".tr()
                                      : null;
                                },
                                text: 'Password'.tr(),
                                icon: Icons.lock_outline,
                                textInputType: TextInputType.text,
                                sufIcon: IconButton(
                                  onPressed: () {
                                    cubit.changePasswordVisibility();
                                  },
                                  icon: Icon(cubit.icon),
                                ),
                                obscure: cubit.isPasswordObscure
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ButtonGlobal(
                              callback: () {
                                print(emailController.text +
                                    passwordController.text);
                                if (validateData(context)) {
                                  cubit.loginWithEmailAndPassword(
                                      email: emailController.text.contains('@') ? emailController.text.trim() :(countryCode +emailController.text.trim()).replaceAll('+', ''),
                                      password: passwordController.text.trim(),
                                      context: context);
                                }
                              },
                              title: "Sign In".tr(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                             /*   InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.forgetPage);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                    child: Text(
                                      "Forget Password ?".tr(),
                                      style: textStyle(context,
                                          size: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),*/
                                InkWell(
                                  onTap: () {
                                   Navigator.pushReplacementNamed(context, Routes.smsPage);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8.0.h),
                                    child: Text(
                                      "Sign with phone".tr(),
                                      style: textStyle(context,
                                          size: 16, fontWeight: FontWeight.bold,color: AppCubit.get(context).primaryColor),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                             SizedBox(
                              height: 75,
                            ),
                           // SocialLogin(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  bottomNavigationBar: Container(
                    height: 50,
                    color:AppCubit.get(context).themeMode == true ?  Colors.grey[800]: Colors.white,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Don\'t have an account ? '.tr(),style: textStyle(context,
                            size: 14, fontWeight: FontWeight.bold),),
                        InkWell(
                          onTap: (() =>
                              Navigator.pushNamed(context, Routes.signUpPage)),
                          child: Text(
                            'Sign Up'.tr(),
                            style: textStyle(context,
                                size: 14, fontWeight: FontWeight.bold,color: AppCubit.get(context).primaryColor),
                          ),
                        )
                      ],
                    ),
                  ),
                );
        }),
    );
  }

  bool validateData(context) {
    if (emailController.text.isEmpty) {
      showToast(
        "Email is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    } else if (passwordController.text.isEmpty) {
      showToast(
        "Password is required".tr(),
        context: context,
        borderRadius: BorderRadius.circular(5),
        animation: StyledToastAnimation.scale,
        reverseAnimation: StyledToastAnimation.fade,
        animDuration: Duration(milliseconds: 250),
      );
      return false;
    } else {
      return true;
    }
  }
}
