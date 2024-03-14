import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../bloc/cubit/app_cubit.dart';

class TextFormGlobal extends StatelessWidget {
  const TextFormGlobal(
      {
        this.hinttext,
        this.maxlines,
        this.controller,
        this.sufIcon,
        required this.validator,
         this.onChange,
        required this.text,
        required this.icon,
         this.onSubmit,
        this.initalval,
        required this.textInputType,
        required this.obscure});
  final dynamic validator, onChange, onSubmit;
  final String text;
  final String? initalval,hinttext;
  final TextInputType textInputType;
  final bool obscure;
  final IconData icon;
  final int? maxlines;
  final Widget? sufIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: const EdgeInsets.only(top: 3, left: 15),
      decoration: BoxDecoration(
          color:AppCubit.get(context).themeMode == true ?  Colors.grey[800]: Colors.white,
          borderRadius: BorderRadius.circular(6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 7,
            )
          ]),
      child: TextFormField(
        maxLines: maxlines == null ? 1 : maxlines,
        controller: controller,
        initialValue: initalval,
        validator: validator,
        onChanged: onChange,
        onFieldSubmitted: onSubmit,
        keyboardType: textInputType,
        obscureText: obscure,
        decoration: InputDecoration(

          suffixIcon: sufIcon,
          icon: Icon(icon),
            labelText: text,
            hintText: hinttext,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.all(0),
            hintStyle: const TextStyle(height: 1)),
      ),
    );
  }
}