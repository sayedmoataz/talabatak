import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../bloc/cubit/app_cubit.dart';
import '../theme/palette.dart';
import '../theme/text_style.dart';

import '../Router.dart';


void createSnackBar(BuildContext context,String message) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 22.w,color: Colors.white,),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            message,
            style: textStyle(context,size: 16.w),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
  );

  // Find the Scaffold in the Widget tree and use it to show a SnackBar!
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

SizedBox buildRowItem(
    BuildContext context,
    AppCubit cubit,
    IconData iconData,
    String text,
    bool arrowStatus,
    ) {
  return SizedBox(
    height: 40,
    child: Row(
      children: [
        Icon(iconData, color:AppCubit.get(context).themeMode == false ? Colors.grey : Colors.white),
        SizedBox(width: 30.0.w),
        Text(
          text,
          style: textStyle(
              context,
              size: 16,
              fontWeight: FontWeight.w600
          ),
        ),
        const Spacer(),
        Icon(
          arrowStatus ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        ),
      ],
    ),
  );
}

Widget myDivider(AppCubit cubit,{double horizontalPad = 15.0,}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 100),
    child: Container(
      width: 200.w,
      height: 3.0,
      decoration: BoxDecoration(
          color:cubit.primaryColor ?? Palette.amber100,
          borderRadius: BorderRadius.circular(15)
      ),
    ),
  );
}

buildRadioListTile(
    BuildContext context,
    {
      required AppCubit cubit,
      required dynamic radioValue,
      required dynamic groupValue,
      required Function(dynamic)? onChangedFun,
      required String titleText,
      Widget? secondaryWidget,
    }) {
  return RadioListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 2.0),
    value: radioValue,
    groupValue: groupValue,
    onChanged: onChangedFun,
    activeColor: cubit.primaryColor,
    title: Text(
      titleText,
      style: textStyle(
          context,
          color: cubit.textColor,size: 13.w),
    ),
    secondary: secondaryWidget,
  );
}
Widget defaultFormField({
  int? lines,
  required TextEditingController controller,
  required TextInputType type,
  dynamic onSubmit,
  dynamic onChange,
  dynamic onTap,
  Color? filColor,
  bool isPassword = false,
  required dynamic validate,
  required String label,
  String? hint,
  required IconData prefix,
  IconData? suffix,
  dynamic suffixPressed,
  BorderRadius? borderRadius,
  bool isClickable = true,
  bool readOnly = false,
}) =>
    TextFormField(
      readOnly: readOnly,
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      maxLines: lines,
      enabled: isClickable,
      onFieldSubmitted: onSubmit,
      onChanged: onChange,
      onTap: onTap,
      validator: validate,
      decoration: InputDecoration(

        filled: true,
        fillColor:filColor,
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(
          prefix,
        ),
        suffixIcon: suffix != null
            ? IconButton(
          onPressed: suffixPressed,
          icon: Icon(
            suffix,
          ),
        )
            : null,
        focusedBorder:borderRadius == null ? InputBorder.none : null,
        enabledBorder: borderRadius == null ? InputBorder.none : null,
        errorBorder:borderRadius == null ? InputBorder.none : null,
        disabledBorder:borderRadius == null ? InputBorder.none : null,
        border:borderRadius != null ? OutlineInputBorder(
            borderRadius: borderRadius
        ) : InputBorder.none,
      ),
    );


Widget conditionalBuilder({bool? condition = false, builder,Widget? fallback}) {
  if (condition == true) {
    return builder;
  } else {
    return fallback!;
  }
}

Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  double radius = 3.0,
  required Function function,
  Function? onTap,
  required String text,
}) =>
    Container(
      width: width,
      height: 50.0,
      child: MaterialButton(
        onPressed: () {
          function();
        },
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          radius,
        ),
        color: background,
      ),
    );



Column buildLanguageColumn(AppCubit cubit, state,context) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      buildRadioListTile(
        context,
        cubit: cubit,
        radioValue: 'en',
        groupValue: cubit.appLanguage,
        onChangedFun: (newVal) {
          cubit.changeAppLanguage(newVal!);
          EasyLocalization.of(context)!.setLocale(Locale('en', 'US'));

        },
        titleText: 'English',
      ),
      ///////////////////////////
      buildRadioListTile(
        context,
        cubit: cubit,
        radioValue: 'ar',
        groupValue: cubit.appLanguage,
        onChangedFun: (newVal) {
          cubit.changeAppLanguage(newVal!);
          EasyLocalization.of(context)!.setLocale(Locale('ar','IQ'));
        },
        titleText: 'arabic',
      ),
    ],
  );
}
Column buildThemeColumn(AppCubit cubit, state,context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      ///////////////////////////////////////

      Text(
        'Accent Color'.tr(),
        style: textStyle(context, size: 14.w),
        textAlign: TextAlign.center,
      ),
      ///////////////////////////////////////
      const SizedBox(height: 15.0),
      ///////////////////////////////////////
      Container(
        height: 25,
        child: ListView.builder(
            itemCount:cubit.defaultColors.length ,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context,index){
              return containerColor(index, cubit, cubit.defaultColors[index]);
            }),
      ),

    ],
  );
}

Padding containerColor(int index, AppCubit cubit, Color color) {
  return Padding(
    padding:  EdgeInsets.symmetric(horizontal: 8.0.w),
    child: InkWell(
      onTap: () {
        cubit.changePrimaryColorIndex(index, color);
      },
      child: Container(
        width: 20.w,
        height: 20.h,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: index == cubit.primaryColorIndex
            ? const Icon(Icons.done, color: Colors.white, size: 15)
            : null,
      ),
    ),
  );
}

Padding buildNotificationOptionRow(BuildContext context,String title,IconData icon, bool isActive, Function(bool) onChange) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0,horizontal: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
                icon,
                color:AppCubit.get(context).themeMode == false ? Colors.grey : Colors.white
            ),
            SizedBox(width: 35,),
            Text(
                title,
                style: textStyle(
                    context,
                    size: 16,
                    fontWeight: FontWeight.w600
                )
            ),
          ],
        ),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor:AppCubit.get(context).primaryColor,
              value: isActive,
              onChanged:onChange ,
            ))
      ],
    ),
  );
}