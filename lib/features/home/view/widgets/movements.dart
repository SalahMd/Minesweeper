import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/helpers/dimenesions.dart';

class Movements extends StatelessWidget {
  final void Function() onBackMove;
  final void Function() onForwardMove;
  final void Function() onSaveBoard;
  const Movements(
      {super.key,
      required this.onBackMove,
      required this.onForwardMove,
      required this.onSaveBoard});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth(context),
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: onBackMove,
            child: Container(
              width: 70.w,
              height: 45.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.darkGrey,
                  border: Border.all(color: AppColors.blueColor)),
              child: Icon(
                Icons.arrow_back,
                size: 25.sp,
                color: AppColors.greyColor,
              ),
            ),
          ).animate().fade(duration: 700.ms, delay: 700.ms).slideX(begin: -0.3),
          GestureDetector(
            onTap: onSaveBoard,
            child: Container(
              width: 50.w,
              height: 50.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.darkGrey,
                  border: Border.all(color: AppColors.blueColor)),
              child: Icon(
                Icons.save,
                size: 25.sp,
                color: AppColors.greyColor,
              ),
            ),
          ).animate().fade(duration: 700.ms, delay: 700.ms).slideY(begin: 0.7),
          GestureDetector(
            onTap: onForwardMove,
            child: Container(
              width: 70.w,
              height: 45.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.darkGrey,
                  border: Border.all(color: AppColors.blueColor)),
              child: Icon(
                Icons.arrow_forward,
                size: 25.sp,
                color: AppColors.greyColor,
              ),
            ),
          ).animate().fade(duration: 700.ms, delay: 700.ms).slideX(begin: 0.3),
        ],
      ),
    );
  }
}
