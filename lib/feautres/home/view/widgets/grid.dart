import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/feautres/home/controller/home_page_controller.dart';
import 'package:untitled/feautres/home/view/widgets/button.dart';

class Grid extends StatelessWidget {
  final int numOfButtons,numOfColumns;
  final HomePageController controller;
  const Grid({super.key, required this.numOfButtons, required this.controller, required this.numOfColumns});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.screenWidth(context),
      alignment: Alignment.center,
      padding: EdgeInsets.all(3.sp),
      color: AppColors.darkGrey,
      child: GridView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: numOfButtons,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:numOfColumns,
          ),
          itemBuilder: (context, index) {
            int x = (index / 8).toInt();
            int y = (index % 8).toInt();
            return  Button(
              row : x,
              col : y,
              controller: controller,
            );
          }),
    );
  }
}
