import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import '../bloc/cubit/app_cubit.dart';
import 'splash_screen.dart';
import '../theme/text_style.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Router.dart';
import '../core/network/local/DbHelper.dart';

class BoardingModel {
  final String image;
  final String header;
  final String body;

  BoardingModel({
    required this.image,
    required this.header,
    required this.body,
  });
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/logo.png',
      header: 'Welcome to talabatek app'.tr(),
      body:
          'Everything you need at your fingertips in one place.'.tr(),
    ),
    BoardingModel(
      image: 'assets/images/on_boarding 2.png',
      header: 'All restaurants, shops, etc. in one place'.tr(),
      body:
          'Search for any store in the area and you will find them all in the same place together'.tr(),
    ),
    BoardingModel(
      image: 'assets/images/on_boarding 3.png',
      header: 'Lowest prices and best products'.tr(),
      body:
          'We have the lowest possible price and our best products as well'.tr(),
    ),
    BoardingModel(
      image: 'assets/images/on_boarding 4.png',
      header: 'The fastest possible delivery'.tr(),
      body:
      'We are distinguished by the speed of delivery and the quality of products and their preservation'.tr(),
    ),
  ];
  PageController pageController = PageController();
  PageController pageImageController = PageController();
  bool isLast = false;
  int pageIndex = 0;
  double indicatorValue = 0.3;
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: boarding.length,
              controller: pageImageController,
              itemBuilder: (context, index) => buildPageViewImage(
                  context: context, size: size, model: boarding[index]),
            ),
            Container(
              width: size.width,
              height: size.height / 2,
              decoration:  BoxDecoration(
                color:AppCubit.get(context).themeMode == true  ? Colors.grey[800] : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(34),
                  topRight: Radius.circular(34),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.0181.h,
                  ),
                  Image.asset(
                    "assets/images/logo.png",
                    width: 47,
                    height: 63.91,
                  ),
                  InkWell(
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

                                        EasyLocalization.of(context)!.setLocale(Locale('en', 'US')).then((value) =>
                                        {
                                          Navigator.pushNamedAndRemoveUntil(context, Routes.welcomeScreen, (route) => false)

                                        });
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
                                        setState(() {
                                          AppCubit.get(context).changeAppLanguage('ar');
                                          Navigator.pushNamedAndRemoveUntil(context, Routes.welcomeScreen, (route) => false);
                                          EasyLocalization.of(context)!.setLocale(Locale('ar','IQ')).then((value) =>
                                          {
                                            Navigator.pushNamedAndRemoveUntil(context, Routes.welcomeScreen, (route) => false)

                                          });
                                        });
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
                                    /*InkWell(
                                      onTap:() {
                                        AppCubit.get(context).changeAppLanguage('tr');
                                        EasyLocalization.of(context)!.setLocale(Locale('tr','TR')).then((value) =>
                                        {
                                        Navigator.pushNamedAndRemoveUntil(context, Routes.welcomeScreen, (route) => false)

                                        });

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
                                    ),*/
                                  ],
                                )
                              ],
                            )
                          ],
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 60.0),
                      child: Container(
                        height: 35.h,
                        decoration: BoxDecoration(
                          color: AppCubit.get(context).primaryColor.withOpacity(0.24),
                          borderRadius: const BorderRadius.all(Radius.circular(13)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.public),
                            SizedBox(width: 14,),
                            Text('Change Language'.tr(),
                                style: textStyle(context,size: 16.sp,fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ) ),
                  SizedBox(
                    height: size.height * 0.0196.h,
                  ),
                  SizedBox(
                    height: size.height * 0.1266.h,
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: pageController,
                      itemCount: boarding.length,
                      itemBuilder: (context, index) => buildPageViewScreen(
                          context: context, size: size, model: boarding[index]),
                      onPageChanged: (index) {
                        setState(() {
                          pageIndex = index;
                          if (index == 0) {
                            indicatorValue = 0.3;
                          } else if (index == 1) {
                            indicatorValue = 0.6;
                          } else {
                            indicatorValue = 1;
                          }
                        });
                        if (index == (boarding.length - 1)) {
                          setState(() {
                            isLast = true;
                          });
                        } else {
                          setState(() {
                            isLast = false;
                          });
                        }
                      },
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.012.h,
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: boarding.length,
                    effect: ExpandingDotsEffect(
                      expansionFactor: 2,
                      activeDotColor: AppCubit.get(context).primaryColor,
                      dotColor: Colors.grey,
                      dotHeight: 6,
                      dotWidth: 20,
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.032,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (pageIndex != 0)
                        TextButton(
                          onPressed: () {
                            pageController.previousPage(
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.fastLinearToSlowEaseIn);
                            pageImageController.previousPage(
                                duration: const Duration(milliseconds: 750),
                                curve: Curves.fastLinearToSlowEaseIn);
                          },
                          child: Text(
                            "previous".tr(),
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      Padding(
                        padding: EdgeInsets.only(left: pageIndex != 0 ? 64 : 0),
                        child: InkWell(
                          onTap: () {
                            if (isLast) {
                              CacheHelper.saveBoolData(key: "firstOpen",value: true);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => SplashScreen(),
                                ),
                              );
                            } else {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 750),
                                  curve: Curves.fastLinearToSlowEaseIn);
                              pageImageController.nextPage(
                                  duration: const Duration(milliseconds: 750),
                                  curve: Curves.fastLinearToSlowEaseIn);
                            }
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  color: AppCubit.get(context).primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(
                                height: 82,
                                width: 82,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: 1,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: 82,
                                width: 82,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: indicatorValue,
                                  valueColor:
                                      AlwaysStoppedAnimation<Color>(AppCubit.get(context).primaryColor,),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.0566,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                    color: AppCubit.get(context).primaryColor.withOpacity(0.24),
                    borderRadius: const BorderRadius.all(Radius.circular(13)),
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () {
                        CacheHelper.saveBoolData(key: "firstOpen",value: true);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SplashScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Skip".tr(),
                        style: textStyle(context),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

Widget buildPageViewScreen({
  required BuildContext context,
  required Size size,
  required BoardingModel model,
}) =>
    Column(
      children: [
        Text(
          model.header,
          style: Theme.of(context).textTheme.headline5!.copyWith(height: 1.4),
        ),
        SizedBox(
          height: size.height * 0.01,
        ),
        Text(
          model.body,
          style: Theme.of(context).textTheme.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );

Widget buildPageViewImage({
  required BuildContext context,
  required Size size,
  required BoardingModel model,
}) =>
    Align(
      alignment: Alignment.topCenter,
      child: Image.asset(
        model.image,
        fit: BoxFit.cover,
        height:320.h ,
        width: size.width,
      ),
    );
