import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/constants/images.dart';
import 'package:untitled/feautres/home/controller/home_page_controller.dart';

class Button extends StatelessWidget {
  final HomePageController controller;
  final int row, col;
  const Button(
      {super.key,
      required this.controller,
      required this.row,
      required this.col});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        controller.onTapButton(row, col);
      },
      onLongPress: () {
        controller.numOfMines--;
        
      },
      child: Container(
          margin: EdgeInsets.all(2.sp),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              3.r,
            ),
            color: controller.mines[row][col] && controller.isLost
                ? AppColors.redColor
                : controller.openedCells[row][col]
                    ? AppColors.greenColor
                    : AppColors.greyColor,
          ),
          child: controller.mines[row][col] && controller.isLost
              ? Image.asset(AppImages.mineImage)
              : Text(controller.cells[row][col] == null
                  ? ''
                  : controller.cells[row][col].toString())),
    );
  }
}
