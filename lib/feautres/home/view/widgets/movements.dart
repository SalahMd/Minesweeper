import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/helpers/dimenesions.dart';

class Movements extends StatelessWidget {
  final void Function() onBackMove;
  final void Function() onForwardMove;
  const Movements(
      {super.key, required this.onBackMove, required this.onForwardMove});

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
                size: 30.sp,
                color: AppColors.greyColor,
              ),
            ),
          ),
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
                size: 30.sp,
                color: AppColors.greyColor,
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 700.ms, delay: 700.ms).slideY(begin: 0.7);
  }
}
