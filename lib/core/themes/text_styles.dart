import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';

class TextStyles {
  static TextStyle bold15(BuildContext context) =>
      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold);
  static TextStyle bold13(BuildContext context) =>
      TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold);
  static TextStyle w40011grey(BuildContext context) => TextStyle(
      color: Colors.grey[700], fontSize: 11.sp, fontWeight: FontWeight.w400);
  static TextStyle bold17(BuildContext context) => TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.bold, color: Colors.grey[400]);
  static TextStyle bold22(BuildContext context) => TextStyle(
      fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white);
  static TextStyle w50018Green(BuildContext context) => TextStyle(
      color: Colors.red[700], fontSize: 18.sp, fontWeight: FontWeight.w500);
  static TextStyle w40014(BuildContext context) =>
      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500);
  static TextStyle w40014Wgite(BuildContext context) => TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor);
  static TextStyle w40014Blue(BuildContext context) => TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: Colors.blue[800]);
}
