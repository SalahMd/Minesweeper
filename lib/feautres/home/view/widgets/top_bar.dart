import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/core/themes/text_styles.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Dimensions.screenWidth(context),
        height: 80.h,
        alignment: Alignment.center,
        color: AppColors.darkGrey,
        child: Text("Minesweeper", style: TextStyles.bold17(context)),
      ),
    );
  }
}
