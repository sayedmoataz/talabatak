import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:upgrader/upgrader.dart';

import '../../Router.dart';
import '../../bloc/AuthCubit/auth_cubit.dart';
import '../../bloc/AuthCubit/auth_states.dart';
import '../../bloc/cubit/app_cubit.dart';
import '../../core/network/local/DbHelper.dart';
import '../../theme/text_style.dart';
import '../../widgets/PopDialog.dart';
import '../FavoritesScreen/favorites_screen.dart';
import '../custom_nav_bar.dart';

class BottomNavigation extends StatefulWidget {
  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    final pageViewController = PageController(initialPage: 2);
    return WillPopScope(
      onWillPop: () async {
        if (CacheHelper.getData(key: 'homePath') != 2) {
          CacheHelper.saveIntData(key: 'homePath', value: 2).then((value) => {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => BottomNavigation()))
              });
          return false;
        } else
          return true;
      },
      child: BlocProvider(
        create: (context) => AuthCubit()
          ..getUserData()
          /*..getUserData()*/
          ..checkfingerPrintSetting()
          ..authBiometric(context),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {},
          builder: (context, state) {
            AppCubit cubit = AppCubit.get(context);
            return UpgradeAlert(
              upgrader: Upgrader(
                  shouldPopScope: () => true,
                  canDismissDialog: true,
                  dialogStyle: Platform.isIOS
                      ? UpgradeDialogStyle.cupertino
                      : UpgradeDialogStyle.material,
                  languageCode: 'ar'),
              child: Scaffold(
                  // resizeToAvoidBottomInset: true,
                  // extendBody: true,
                  appBar: AppBar(
                    title: Padding(
                      padding: EdgeInsets.only(right: 25.0.w, left: 25.w),
                      child: GradientText(
                        'talabatek'.tr(),
                        colors: [
                          cubit.primaryColor,
                          cubit.themeMode == true ? Colors.white : Colors.black,
                        ],
                        gradientType: GradientType.linear,
                        radius: 6,
                        style: textStyle(context,
                            size: 22.sp,
                            fontWeight: FontWeight.bold,
                            letterSpaceing: 1.5),
                      ),
                    ),
                    centerTitle: true,
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    actions: [
                      CacheHelper.getData(key: "isLogged") == false
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                elevation: 1,
                                color: cubit.primaryColor,
                                //  cubit.themeMode == true
                                //     ? Colors.grey[800]
                                //     : Colors.grey[100],
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamedAndRemoveUntil(context,
                                        Routes.smsPage, (route) => false);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Sign In".tr(),
                                      style: textStyle(context,
                                          size: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Card(
                                elevation: 1,
                                color: cubit.themeMode == true
                                    ? Colors.grey[800]
                                    : Colors.grey[100],
                                child: InkWell(
                                  onTap: () {
                                    CacheHelper.getData(key: "isLogged") ==
                                            false
                                        ? popDialog(
                                            context: context,
                                            title: 'Login First'.tr(),
                                            content:
                                                'Please Sign In First'.tr(),
                                            boxColor: Colors.red)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    FavoritesScreen()));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/gifs/fav.gif',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      Card(
                        elevation: 0,
                        color: cubit.primaryColor,
                        //  cubit.themeMode == true
                        //     ? Colors.grey[800]
                        //     : Colors.grey[100],
                        child: InkWell(
                          onTap: () {
                            CacheHelper.getData(key: "isLogged") == false
                                ? popDialog(
                                    context: context,
                                    title: 'Login First'.tr(),
                                    content: 'Please Sign In First'.tr(),
                                    boxColor: Colors.red)
                                : Navigator.pushNamed(
                                    context, Routes.notificationScreen);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Track Order".tr(),
                              style: textStyle(
                                context,
                                size: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          //  Image.asset(
                          //   'assets/gifs/notification.gif',
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ],
                  ),
                  bottomNavigationBar: Container(
                      width: MediaQuery.of(context).size.width,
                      margin:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                      child: CustomBottomNavigationBar(
                        selectedIconList: [
                          // Icons.home,
                          // Icons.category_outlined,
                          Icons.shopping_cart,
                          Icons.work_history_outlined,
                          Icons.settings_suggest_outlined,
                        ],
                        unselectedIconList: [
                          // Icons.home_outlined,
                          // Icons.category,
                          Icons.shopping_cart,
                          Icons.work,
                          Icons.settings,
                        ],
                        titleList: [
                          // 'Home'.tr(),
                          // 'Categories'.tr(),
                          'Cart'.tr(),
                          'Restaurants'.tr(),
                          'Settings'.tr(),
                        ],
                        onChange: (index) {
                          setState(() {
                            CacheHelper.saveIntData(
                                key: 'homePath', value: index);
                          });
                        },
                        defaultSelectedIndex:
                            CacheHelper.getData(key: 'homePath') ?? 1,
                      )),
                  body:
                      cubit.screens[CacheHelper.getData(key: 'homePath') ?? 1]),
            );
          },
        ),
      ),
    );
  }
}

/*
 Container(
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(45), topLeft: Radius.circular(45)),
              boxShadow: [
                BoxShadow(color: Colors.white54, spreadRadius: 0, blurRadius: 30),
              ],
            ),
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedItemColor: cubit.primaryColor ?? Palette.black,
                unselectedItemColor: Colors.grey[500],
                showUnselectedLabels: true,
                elevation: 1,
                selectedLabelStyle: TextStyle( fontSize:  12),
                currentIndex: cubit.bottomNavIndex,
                onTap: (index) {
                  cubit.changeBottomNavIndex(index);
                },
                items: [
                  BottomNavigationBarItem(
                      icon: Icon(
                          Icons.home_outlined,
                      ),
                      activeIcon: Icon(
                        Icons.home,
                      ),
                      label: AppStrings.home
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                          Icons.business_center_outlined
                      ),
                      label: AppStrings.freelance
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                          Icons.work_outline
                      ),
                      label: AppStrings.jobs
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                          Icons.notifications_outlined
                      ),
                      label: AppStrings.notifications
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                          Icons.post_add
                      ),
                      label: AppStrings.companyReviews
                  ),
                ],
              ),
          )
*/
