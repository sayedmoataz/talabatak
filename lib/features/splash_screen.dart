import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Router.dart';
import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import '../core/network/local/DbHelper.dart';
import '../core/network/local/notofication.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotifyHelper notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.displayNotification(
      title: "Welcome in Changing app".tr(),
      body: 'I hope you like our app'.tr(),
    );
    notifyHelper.scheduledNotification();
    return BlocProvider.value(
      value: BlocProvider.of<AppCubit>(context)..splashTimer(),
      child: BlocListener<AppCubit, AppStates>(
          listener: (context, state) {
            if (state is SplashscreenLoading)
              CacheHelper.getData(key: "isLogged") == true
                  ? Navigator.pushReplacementNamed(context, Routes.homeScreen)
                  : Navigator.pushReplacementNamed(context, Routes.smsPage);
            else
              print(state);
          },
          child: Scaffold(
              body: Image.asset(
            AppCubit.get(context).themeMode == true
                ? 'assets/gifs/splash.gif'
                : 'assets/gifs/splash.gif',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
          ))),
    );
  }
}
