import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/constants/images.dart';
import 'package:untitled/features/home/controller/home_page_controller.dart';
import '../../model/board.dart';

class Button extends StatelessWidget {
  final HomePageController controller;
  final int row, col;
  final Board board;
  const Button(
      {super.key,
      required this.controller,
      required this.row,
      required this.col,
      required this.board});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        controller.onTapButton(row, col, board);
      },
      onLongPress: () {
        controller.setFlag(board, row, col);
      },
      child: Container(
          margin: EdgeInsets.all(2.sp),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              3.r,
            ),
            border: board.openedCells[row][col].first
                ? Border.all(color: AppColors.blueColor, width: 2)
                : null,
            color: board.mines[row][col] && board.isLost
                ? AppColors.redColor
                : board.openedCells[row][col].first
                    ? AppColors.greenColor
                    : AppColors.greyColor,
          ),
          child: board.mines[row][col] && board.isLost
              ? Image.asset(AppImages.mineImage)
              : board.cells[row][col] == "f"
                  ? Image.asset(AppImages.flag)
                  : Text(board.cells[row][col] != "f" &&
                          board.cells[row][col] != null &&
                          board.cells[row][col] != 'ff'
                      ? board.cells[row][col].toString()
                      : '')),
    );
  }
}
