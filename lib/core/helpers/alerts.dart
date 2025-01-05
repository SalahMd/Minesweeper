import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/themes/text_styles.dart';

Future<bool> animationedAlert(
    var animation, String title, Function() onYesTap, BuildContext context,
    {IconData? icon = Icons.replay}) {
  Get.defaultDialog(
      backgroundColor: AppColors.greyColor,
      title: title,
      titleStyle: TextStyles.w40014(context),
      titlePadding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 10.w),
      content: animation != null
          ? Container(
              alignment: Alignment.topCenter, height: 80.h, child: animation)
          : null,
      barrierDismissible: false,
      actions: [
        GestureDetector(
            onTap: onYesTap,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: Icon(
                  icon,
                  size: 25.sp,
                ))),
      ]);
  return Future.value(true);
}
