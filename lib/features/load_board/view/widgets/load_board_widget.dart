import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jiffy/jiffy.dart';
import 'package:untitled/core/constants/colors.dart';

import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/core/themes/text_styles.dart';

class LoadBoardWidget extends StatelessWidget {
  final String boardName;
  final String date;
  final void Function() onLoad;
  final int id;
  const LoadBoardWidget(
      {super.key,
      required this.boardName,
      required this.date,
      required this.onLoad,
      required this.id});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLoad,
      child: Container(
        decoration: (BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.loadBoardColor,
        )),
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        width: Dimensions.screenWidth(context),
        padding: EdgeInsets.all(15.sp),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  boardName,
                  style: TextStyles.w40014(context),
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(Jiffy.parse(date)
                    .format(pattern: 'y/MMM/EE  h:m')
                    .toString())
              ],
            ),
           
          ],
        ),
      ),
    );
  }
}
