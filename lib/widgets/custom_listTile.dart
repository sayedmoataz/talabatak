import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/text_style.dart';

class CustomListTile extends StatelessWidget {
  final IconData? leadingIcon;
  final String? title;
  final VoidCallback? press;

  CustomListTile({this.leadingIcon, this.title,this.press});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      child: ListTile(
          onTap: press!,
          leading: Icon(leadingIcon,),
          title: Text(title!,style: textStyle(
            context,
              size: 16,
              fontWeight: FontWeight.w600
          )),
          trailing:Icon(Icons.arrow_right)),
    );
  }
}