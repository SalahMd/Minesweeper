import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/constants/images.dart';
import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/core/themes/text_styles.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      body: Stack(
        children: [
          SizedBox(
            width: Dimensions.screenWidth(context),
            height: Dimensions.screenHeight(context),
            child: Image.asset(
              AppImages.logo,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 250.h,
              ),
              Center(
                  child: SafeArea(
                      child: Text(
                'Mineswweper',
                style: TextStyles.bold25(context),
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
                  height: 55.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.darkGrey,
                      border: Border.all(width: 2)),
                  child:
                      Text('New game', style: TextStyles.w50016White(context)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed("LoadBoard");
                },
                child: Container(
                  width: 230.w,
                  height: 55.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.darkGrey,
                      border: Border.all(width: 2)),
                  child:
                      Text('Load game', style: TextStyles.w50016White(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
