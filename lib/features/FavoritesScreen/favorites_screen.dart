import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'views/product_fav_view.dart';
import 'views/shops_fav_view.dart';
import '../../theme/text_style.dart';

import '../../Router.dart';
import '../../bloc/cubit/app_cubit.dart';

class FavoritesScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length:2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppCubit.get(context).primaryColor,
          title: Text(
            "Favorites".tr(),
            style: textStyle(
              context,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.w600,
              size: 20.sp,
            ),
          ),
          centerTitle: true,
          leading: InkWell(
            onTap: () {
              AppCubit.get(context).bottomNavIndex = 0;
              Navigator.pushReplacementNamed(context, Routes.homeScreen);
            },
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new_outlined),
            ),
          ),
          elevation: 0,
          bottom: TabBar(
              labelColor: AppCubit.get(context).primaryColor,
              unselectedLabelColor:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.white),
              tabs: [
               /* Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Ads".tr(),
                      style: textStyle(
                        context,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),*/
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Restaurants".tr(),
                      style: textStyle(
                        context,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Products".tr(),
                      style: textStyle(
                        context,
                        size: 14.sp,
                      ),
                    ),
                  ),
                ),

              ]),
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              FavShopsView(),
              FavProudctView(),
            ],
          ),
        ),
      ),
    );
  }
}
