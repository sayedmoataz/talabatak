import 'package:country_code_picker/country_code_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/AuthCubit/auth_cubit.dart';
import '../../bloc/AuthCubit/auth_states.dart';
import '../../bloc/cubit/app_cubit.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../../Router.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../../widgets/loading.dart';

class PhoneRegPage extends StatefulWidget {
  static final routeName = "phone-page";
  @override
  _PhoneRegPageState createState() => _PhoneRegPageState();
}

class _PhoneRegPageState extends State<PhoneRegPage> {
  String phoneNumber = "";
  String countryCode = '+972';
  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);
    final mQ = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit,AuthStates>(
      builder: (context,state){

      /*  if(state is LogInInitialState){
          return LoadingScreen    ();
        }

        else {*/
          var cubit = AppCubit.get(context);
          return   SafeArea(
            child: Scaffold(
              body: ListView(
                children: <Widget>[
                  HeaderWidget(height: mQ.height * 0.44),
                  SizedBox(
                    height: mQ.height * 0.03,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Hello, nice to meet you!".tr(),
                          style: textStyle(
                              context,
                              size: 12.sp
                          ),
                        ),
                        SizedBox(height: mQ.height * 0.01),
                        Text(
                          "Get moving with Talabatek App".tr(),
                          style: textStyle(
                              context,
                              size: 16.sp
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: mQ.height * 0.05,
                  ),
                  Card(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    elevation: 6.0,
                    shape:
                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: CountryCodePicker(
                              dialogSize: Size(600, 400),
                              hideSearch: false,
                              backgroundColor: Colors.grey[800],
                              dialogBackgroundColor: Colors.grey[800],
                              barrierColor: Colors.transparent,
                              onChanged: (e) {
                                countryCode = e.dialCode!;
                                print(countryCode);
                              },
                              // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                              initialSelection: 'IL',
                              favorite: ['PS', 'IL','EG'],
                              // optional. Shows only country name and flag
                              showCountryOnly: false,
                              // optional. Shows only country name and flag when popup is closed.
                              showOnlyCountryWhenClosed: false,

                              // optional. aligns the flag and the Text left
                              alignLeft: false,
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: TextField(
                                onChanged: (value){
                                  const english = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
                                  const arabic = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

                                  for (int i = 0; i < english.length; i++) {
                                    value = value.replaceAll(arabic[i], english[i]);
                                  }
                                  print("$value");
                                  phoneNumber = value;
                                  print(phoneNumber);
                                },
                                // autofocus: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Enter your mobile number".tr(),
                                  hintStyle: textStyle(
                                      context,
                                      size: 12.sp
                                  ),
                                ),
                                onSubmitted: (e) {
                                  AuthCubit.get(context).phoneAuth(countryCode, phoneNumber, context);
                                },
                                keyboardType: TextInputType.number,
                              )),

                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 25,),
                  InkWell(
                    onTap: (){
                      if(phoneNumber.isEmpty || phoneNumber.length < 9 || phoneNumber.length > 10 ){
                        popDialog(
                            context: context,
                            title: 'Something wrong happen'.tr(),
                            content:'Please add your phone'.tr(),
                            boxColor: Colors.red
                        );
                      }else{
                        AuthCubit.get(context).phoneAuthApi(countryCode.replaceAll('+',''), phoneNumber.startsWith('0') ? phoneNumber.substring(1) : phoneNumber, context);

                      }
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: 20, right: 20,),
                      elevation: 6.0,
                      color: cubit.primaryColor,
                      shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Center(child: Text('SIGN IN'.tr(),
                          style: textStyle(context,fontWeight: FontWeight.bold,size: 16.sp),)),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.loginPage);
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0.h,horizontal: 16.w),
                      child: Text(
                        "Sign with Email".tr(),
                        style: textStyle(context,
                            size: 16, fontWeight: FontWeight.bold,color: AppCubit.get(context).primaryColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: mQ.height * 0.06,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40, right: 40),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'By creating an account, you agree to our'.tr(),
                            style:textStyle(
                                context,
                                size: 12.sp
                            ),
                          ),
                          TextSpan(
                            text: ' Terms of Service'.tr(),
                            style: textStyle(
                                context,
                                size: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: cubit.primaryColor
                            ),
                          ),
                          TextSpan(
                            text: ' and '.tr(),
                            style:textStyle(
                              context,
                              size: 12.sp,

                            ),
                          ),
                          TextSpan(
                            text: 'Privacy Policy'.tr(),
                            style:textStyle(
                                context,
                                size: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: cubit.primaryColor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
   //     }
      },
      listener: (context,state){

      },
    );

  }
}

class HeaderWidget extends StatelessWidget {
  final double height;

  const HeaderWidget({required this.height});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: height,
        color: Color(0xff2dbb54),
        child: Column(
          children: [
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
            Center(
              child: Container(
                width: 250.w,
                child:Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                    ),
                    GradientText('talabatek'.tr(),
                      colors: [
                        AppCubit.get(context).themeMode == true ? Colors.white : Colors.black,
                        AppCubit.get(context).themeMode == true ? Colors.white : Colors.black,
                      ],
                      gradientType: GradientType.linear,
                      radius: 6,
                      style: textStyle(context,
                          size: 22.sp,fontWeight: FontWeight.bold,letterSpaceing: 1.5),),
                  ],
                )
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NoLogoHeaderWidget extends StatelessWidget {
  final double height;

  const NoLogoHeaderWidget({required this.height});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        height: height,
        color: Color(0xff2dbb54),
        child: Center(
          child: Container(
            width: 200,
          ),
        ),
      ),
    );
  }
}


class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 150);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 150);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return false;
  }
}