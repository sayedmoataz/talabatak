import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../bloc/AuthCubit/auth_cubit.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../theme/text_style.dart';

import '../../Router.dart';
import '../../widgets/button.dart';
import '../../widgets/textFormWidget.dart';



class ForgetView extends StatelessWidget {
  ForgetView({Key? key}) : super(key: key);
  String email = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 40,
                ),
                Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/images/logo.png")
                ),
                const SizedBox(height: 50),
                Text(
                    'Reset your account'.tr(),
                    style:textStyle(context,
                        size: 16,
                        fontWeight: FontWeight.w600)
                ),
                const SizedBox(
                  height: 15,
                ),
                // Email input field
                TextFormGlobal(
                  validator: (value) {
                    return value!.isEmpty ? "Enter your Email".tr() : null;
                  },
                  onSubmit: (val){
                    email = val;

                  },
                  onChange:(val)
                  {
                    email = val;
                  },
                  text: 'Email'.tr(),
                  icon: Icons.email_outlined,
                  obscure: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(
                  height: 20,
                ),

                const SizedBox(
                  height: 20,
                ),
                ButtonGlobal(
                  callback: (){
                    //AuthCubit.get(context).resetPassowrd(email: email,context: context);
                  },
                  title: "Reset Password".tr(),
                ),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        color: AppCubit.get(context).themeMode == true ?  Colors.grey[800]:Colors.white,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Back To '.tr()),
            InkWell(
              onTap: (() => Navigator.pushReplacementNamed(context, Routes.loginPage)),
              child: Text(
                'Log In'.tr(),
                style: textStyle(context,
                    size: 14,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
    );
  }
}