import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle display(BuildContext context, {double size = 36, FontWeight weight = FontWeight.w700, Color? color}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color ?? Theme.of(context).textTheme.bodyLarge?.color);

  static TextStyle heading(BuildContext context, {double size = 22, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color ?? Theme.of(context).textTheme.bodyLarge?.color);

  static TextStyle body(BuildContext context, {double size = 16, FontWeight weight = FontWeight.w400, Color? color}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color ?? Theme.of(context).textTheme.bodyLarge?.color);

  static TextStyle caption(BuildContext context, {double size = 12, Color? color}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: FontWeight.w400, color: color ?? Theme.of(context).textTheme.bodyMedium?.color);

  static TextStyle label(BuildContext context, {double size = 14, FontWeight weight = FontWeight.w600, Color? color}) =>
      GoogleFonts.dmSans(fontSize: size, fontWeight: weight, color: color ?? Theme.of(context).textTheme.bodyLarge?.color);
}
