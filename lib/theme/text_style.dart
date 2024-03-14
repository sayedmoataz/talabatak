import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/painting/text_style.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle textStyle (BuildContext context,{double? size , double? spacing , FontWeight? fontWeight , Color? color,double? letterSpaceing,TextDecoration? textDecoration}){
  return EasyLocalization.of(context)!.locale == Locale('en', 'US')?GoogleFonts.poppins(
      fontSize: size,
      letterSpacing:letterSpaceing ?? 1,
      fontWeight: fontWeight,
      color: color,
      decoration: textDecoration
  ): GoogleFonts.cairo(
      fontSize: size,
      letterSpacing:spacing,
      fontWeight: fontWeight,
      color: color,
      decoration: textDecoration

  );
}