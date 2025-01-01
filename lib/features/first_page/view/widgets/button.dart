import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/themes/text_styles.dart';

class Button extends StatelessWidget {
  final String name;
  final void Function() onTap;
  const Button({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 230.w,
        height: 55.h,
        margin: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.darkGrey,
            border: Border.all(width: 2)),
        child: Text(name, style: TextStyles.w50016White(context)),
      ),
    );
  }
}
