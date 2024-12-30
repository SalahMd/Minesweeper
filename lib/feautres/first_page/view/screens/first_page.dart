import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/themes/text_styles.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 250.h,
            ),
            Center(
                child: SafeArea(
                    child: Text(
              'Mineswweper',
              style: TextStyles.bold22(context),
            ))),
            SizedBox(
              height: 20.h,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed('HomePage');
              },
              child: Container(
                width: 230.w,
                height: 45.h,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.darkGrey, border: Border.all()),
                child: Text('New game', style: TextStyles.w40014Wgite(context)),
              ),
            ),
              GestureDetector(
              onTap: () {
                Get.toNamed("LoadBoard");
              },
              child: Container(
                width: 230.w,
                height: 45.h,
                margin: EdgeInsets.symmetric(vertical: 10.h),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColors.darkGrey, border: Border.all()),
                child: Text('Load game', style: TextStyles.w40014Wgite(context)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
