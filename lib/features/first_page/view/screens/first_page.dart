import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/core/constants/images.dart';
import 'package:untitled/core/helpers/dimenesions.dart';
import 'package:untitled/core/themes/text_styles.dart';
import 'package:untitled/features/first_page/view/widgets/button.dart';

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
                'Minesweeper',
                style: TextStyles.bold25(context),
              ))),
              SizedBox(
                height: 20.h,
              ),
                Button(
                  name: 'New game',
                  onTap: () {
                    Get.toNamed("HomePage");
                  }),
              Button(
                  name: 'Load game',
                  onTap: () {
                    Get.toNamed("LoadBoard");
                  })
            ],
          ),
        ],
      ),
    );
  }
}
