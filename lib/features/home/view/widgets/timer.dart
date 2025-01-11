import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/constants/images.dart';
import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/core/themes/text_styles.dart';
import 'package:untitled/features/home/controller/home_page_controller.dart';

class Timer extends StatelessWidget {
  final int numOfMines, numOfBoard;
  final HomePageController controller;
  const Timer(
      {super.key,
      required this.numOfMines,
      required this.controller,
      required this.numOfBoard});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth(context),
      height: 100.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 80.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.blackColor,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                    width: 30.sp,
                    height: 30.sp,
                    child: Image.asset(
                      AppImages.mineImage,
                      color: AppColors.redColor,
                    )),
                Text(
                  numOfMines.toString(),
                  style: TextStyles.w50018red(context),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.initBoard(true, boardId: numOfBoard);
            },
            child: Container(
                width: 60.w,
                height: 50.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.r),
                  color: AppColors.darkGrey,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.replay_outlined,
                  size: 25.sp,
                )),
          ),
          Container(
            width: 80.w,
            height: 50.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.blackColor,
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(
                  Icons.timer,
                  size: 22.sp,
                  color: AppColors.redColor,
                ),
                Text(
                  controller.getBoard(numOfBoard).seconds.toString(),
                  style: TextStyles.w50018red(context),
                ),
              ],
            ),
          )
        ],
      ),
    ).animate().fade(duration: 700.ms, delay: 300.ms).slideX(begin: -0.3);
  }
}
