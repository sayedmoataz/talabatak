import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../bloc/AuthCubit/auth_cubit.dart';
import '../bloc/cubit/app_cubit.dart';
import '../bloc/cubit/app_states.dart';
import '../components/components.dart';
import '../models/notification_model.dart';
import '../theme/text_style.dart';
import '../widgets/LoadingShimmer.dart';
import '../widgets/empty_widget.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getNotification(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = AuthCubit.get(context).userModel;
          if (userModel == null ||
              AppCubit.get(context).notificationModel == null) {
            return VListLoading(
              scroll: Axis.vertical,
            );
          } else
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Notifications".tr(),
                  style: textStyle(context,
                      size: 20.sp, fontWeight: FontWeight.bold),
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back_ios_new_rounded),
                ),
              ),
              body: SingleChildScrollView(
                child: conditionalBuilder(
                    condition: AppCubit.get(context)
                            .notificationModel!
                            .results!
                            .length >
                        0,
                    builder: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => buildNotificationItem(
                          context,
                          AppCubit.get(context)
                              .notificationModel!
                              .results![index],
                          index),
                      itemCount: AppCubit.get(context)
                          .notificationModel!
                          .results!
                          .length,
                    ),
                    fallback: Center(
                        child: EmptyWidget('No Notifications yet'.tr()))),
              ),
            );
        },
      ),
    );
  }

  Widget buildNotificationItem(context, Results model, index) {
    // var cubit = AppCubit.get(context);
    var newDesc = model.description!
        .replaceAll('finished', 'منتهية')
        .replaceAll('preparing', 'قيد التحضير')
        .replaceAll('complete', 'تم التوصيل بنجاح')
        .replaceAll('rejected', 'مرفوض')
        .replaceAll('not started', 'عدم البدء')
        .replaceAll('in the Way', 'في الطريق');
    return Card(
      margin: EdgeInsets.all(6.0),
      elevation: 1,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 25,
              ),
              Container(
                height: 60.h,
                width: 195.w,
                child: ListTile(
                  title: Text(model.title!),
                  subtitle: Text(newDesc),
                ),
              ),
              Container(
                height: 60.h,
                width: 100.w,
                alignment: Alignment.center,
                child: ListTile(
                  title: Text(
                    DateFormat.yMMMd()
                        .format(DateTime.parse(model.createdAt!.toString())),
                    style: textStyle(context,
                        size: 10.sp, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat.jm()
                        .format(DateTime.parse(model.createdAt!.toString())),
                    textAlign: TextAlign.center,
                    style: textStyle(
                      context,
                      size: 10.sp,
                    ),
                  ),
                ),
              )
            ],
          )),
    );
  }
}
