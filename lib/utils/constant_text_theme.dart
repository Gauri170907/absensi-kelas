import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

TextTheme myTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'Gilroy',
    fontSize: ScreenUtil().setSp(57),
  ),
  displayMedium:
      TextStyle(fontFamily: 'Gilroy', fontSize: ScreenUtil().setSp(45)),
  displaySmall:
      TextStyle(fontFamily: 'Gilroy', fontSize: ScreenUtil().setSp(40)),
  headlineLarge: TextStyle(
    fontFamily: 'Gilroy',
    fontSize: ScreenUtil().setSp(32),
    fontWeight: FontWeight.w400,
  ),
  headlineMedium: TextStyle(
    fontFamily: 'Gilroy',
    fontSize: ScreenUtil().setSp(28),
    fontWeight: FontWeight.w400,
  ),
  headlineSmall: TextStyle(
    fontFamily: 'Gilroy',
    fontSize: ScreenUtil().setSp(24),
    fontWeight: FontWeight.w400,
  ),
  titleLarge: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(22),
      fontWeight: FontWeight.bold),
  titleMedium: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(18),
      fontWeight: FontWeight.bold,
      letterSpacing: 0.15),
  titleSmall: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.bold,
      letterSpacing: 0.1),
  labelLarge: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(14),
      letterSpacing: 0.1),
  labelMedium: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(12),
      letterSpacing: 0.5),
  labelSmall: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(11),
      letterSpacing: 0.5),
  bodyLarge: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(16),
      fontWeight: FontWeight.w300,
      letterSpacing: 0.15),
  bodyMedium: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(14),
      fontWeight: FontWeight.w300,
      letterSpacing: 0.25),
  bodySmall: TextStyle(
      fontFamily: 'Gilroy',
      fontSize: ScreenUtil().setSp(12),
      fontWeight: FontWeight.w300,
      letterSpacing: 0.4),
);
