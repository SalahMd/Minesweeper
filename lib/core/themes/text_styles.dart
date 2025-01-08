import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';

class TextStyles {
  static TextStyle bold17(BuildContext context) => TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.grey[400]);
  static TextStyle bold25(BuildContext context) => TextStyle(
      fontSize: 25.sp, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle w50018red(BuildContext context) => TextStyle(
      color: Colors.red[700], fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle w40014(BuildContext context) =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
      static TextStyle w40012(BuildContext context) =>
      TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400);
  static TextStyle w50014White(BuildContext context) => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor);
  static TextStyle w50016White(BuildContext context) => TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor);
}
