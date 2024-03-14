import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/AuthCubit/auth_cubit.dart';
import 'phone_screen.dart';
import '../../theme/text_style.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'dart:ui' as ui;

import '../../bloc/AuthCubit/auth_states.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../widgets/loading.dart';
class OtpPage extends StatefulWidget {

  final String phoneNumber;
  final String verificationCode;

  OtpPage({required this.phoneNumber,required this.verificationCode});
  static final routeName = "otp-page";
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String txtOpt = '';
  @override
  Widget build(BuildContext context) {
    final mQ = MediaQuery.of(context).size;
    return BlocConsumer<AuthCubit,AuthStates>(
      builder: (context,state){

        var cubit = AppCubit.get(context);
        return Scaffold(
          body: ListView(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  HeaderWidget(height: mQ.height * 0.5),
                  Positioned(
                    top: 20.0,
                    left: 0.0,
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.white,
                      textColor: Colors.green,
                      child: Icon(
                        Icons.arrow_back,
                        size: 15,
                      ),
                      padding: EdgeInsets.all(6),
                      shape: CircleBorder(),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: mQ.height * 0.03,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text("Phone Verification".tr(), style: textStyle(context,)),
                    SizedBox(height: mQ.height * 0.01),
                    Text(
                      "Enter your OTP code below".tr(),
                      style: textStyle(context,size: 16.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: mQ.height * 0.05,
              ),
              Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  elevation: 6.0,
                  shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                              flex: 3,
                              child: PinCodeTextField(
                                keyboardType: TextInputType.number,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                length: 6,
                                /*    onCompleted: (val){
                              AuthCubit.get(context).otpSignIn(
                                  widget.phoneNumber,
                                  widget.verificationCode,
                                  val,
                                  context
                              );
                            },*/

                                animationType: AnimationType.fade,
                                animationDuration: Duration(milliseconds: 300),

                                autoFocus: true,
                                onChanged: (value) {
                                  setState(() {
                                    txtOpt = value;
                                  });
                                }, appContext: context,
                              )),
                          Expanded(
                              flex: 1,
                              child: MaterialButton(
                                onPressed: () {
                                  AuthCubit.get(context).otpSignInApi(
                                      widget.phoneNumber,
                                      widget.verificationCode,
                                      txtOpt,
                                      context
                                  );
                                },
                                color: Colors.green,
                                textColor: Colors.white,
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 15,
                                ),
                                padding: EdgeInsets.all(6),
                                shape: CircleBorder(),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: mQ.height * 0.1,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: RichText(
                  textAlign: TextAlign.start,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Don\'t waste'.tr(),
                        style:textStyle(
                          context,
                          size: 12.sp,

                        ),
                      ),
                      TextSpan(
                        text: ' your code and sign now'.tr(),
                        style: textStyle(
                          context,
                          size: 12.sp,

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      listener: (context,state){
        /*if(state is LogInInitialState){
          LoadingScreen();
        }*/
      },
    );

  }
}