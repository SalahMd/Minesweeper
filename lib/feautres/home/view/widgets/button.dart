import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/constants/images.dart';
import 'package:untitled/feautres/home/controller/home_page_controller.dart';

class Button extends StatelessWidget {
  final HomePageController controller;
  final int row, col;
  final int boardNum;
  const Button(
      {super.key,
      required this.controller,
      required this.row,
      required this.col,
      required this.boardNum});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.onTapButton(row, col,controller.boards[boardNum] );
      },
      onLongPress: () {
        controller.setFlag(controller.boards[boardNum], row, col);
      },
      child: Container(
          margin: EdgeInsets.all(2.sp),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              3.r,
            ),
            border: controller.boards[boardNum].openedCells![row][col]
                ? Border.all(color: AppColors.blueColor, width: 2)
                : null,
            color: controller.boards[boardNum].mines![row][col] &&
                    controller.boards[boardNum].isLost!
                ? AppColors.redColor
                : controller.boards[boardNum].openedCells![row][col]
                    ? AppColors.greenColor
                    : AppColors.greyColor,
          ),
          child: controller.boards[boardNum].mines![row][col] &&
                  controller.boards[boardNum].isLost!
              ? Image.asset(AppImages.mineImage)
              : controller.boards[boardNum].cells![row][col] == "f"
                  ? Image.asset(AppImages.flag)
                  : Text(controller.boards[boardNum].cells![row][col] != "f" &&
                          controller.boards[boardNum].cells![row][col] != null
                      ? controller.boards[boardNum].cells![row][col].toString()
                      : '')),
    );
  }
}
