import 'package:flutter/material.dart';
import '../bloc/cubit/app_cubit.dart';
import '../theme/palette.dart';
import '../theme/text_style.dart';

Widget defaultMaterialButton({
  required BuildContext context,
  required Color bgColor,
  required Color textColor,
  required String label,
  required IconData icon,
  required VoidCallback press,
}) => SizedBox(
  width: double.infinity,
  child: MaterialButton(
    onPressed: press,
    height: 49,
    color: bgColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      side: BorderSide.none,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          label,
          style: textStyle(context,size:12,color: Colors.white, fontWeight: FontWeight.bold),
        ),
        Icon(icon,color: Colors.white,)
      ],
    )
  ),
);
class ButtonGlobal extends StatelessWidget {
  VoidCallback? callback;
  String? title;
  double? hight;
   ButtonGlobal({Key? key, this.callback,this.title,this.hight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:callback,
      child: Container(
        alignment: Alignment.center,
        height: hight ?? 55,
        decoration: BoxDecoration(
            color: AppCubit.get(context).primaryColor,

            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
              )
            ]),
        child:  Text(
            title!,
          style: textStyle(context,size:18,color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}