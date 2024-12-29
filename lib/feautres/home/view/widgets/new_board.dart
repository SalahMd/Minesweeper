import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/themes/text_styles.dart';

class NewBoard extends StatelessWidget {
  final void Function() onNewBoard;
  const NewBoard({super.key, required this.onNewBoard});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: GestureDetector(
      onTap: onNewBoard,
      child: Container(
        width: 180.w,
        padding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 10.w),
        margin: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.darkGrey,
            border: Border.all(color: AppColors.blueColor)),
        child: Text(
          "New board",
          style: TextStyles.w40014Wgite(context),
        ),
      ),
    ));
  }
}
