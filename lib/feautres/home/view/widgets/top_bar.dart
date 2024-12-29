import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/core/themes/text_styles.dart';

class TopBar extends StatelessWidget {
  final String title;
  const TopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: Dimensions.screenWidth(context),
        height: 80.h,
        alignment: Alignment.center,
        color: AppColors.darkGrey,
        child: Text(title, style: TextStyles.bold17(context)),
      ),
    ).animate().fade(duration: 700.ms).slideY(begin: 0.2);
  }
}
