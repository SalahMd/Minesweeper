import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/features/home/controller/home_page_controller.dart';
import 'package:untitled/features/home/view/widgets/board.dart';
import 'package:untitled/features/home/view/widgets/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController(context: context));
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(
              title: "Minesweeper",
            ),
            GetBuilder<HomePageController>(
              builder: (controller) => ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: controller.boards.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return Board(
                    controller: controller,
                    boardNum: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
