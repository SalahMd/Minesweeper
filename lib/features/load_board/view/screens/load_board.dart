import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/features/home/view/widgets/top_bar.dart';
import 'package:untitled/features/load_board/controller/load_board_controller.dart';
import 'package:untitled/features/load_board/view/widgets/load_board_widget.dart';

class LoadBoard extends StatelessWidget {
  const LoadBoard({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(LoadBoardController());
    return Scaffold(
      backgroundColor: AppColors.greyColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const TopBar(title: "Load board"),
            SizedBox(
              height: 20.h,
            ),
            GetBuilder<LoadBoardController>(
              builder: (controller) => ListView.builder(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.loadedBoardModels.length,
                  itemBuilder: (context, index) {
                    return LoadBoardWidget(
                      boardName: 'Saved board ${index + 1}',
                      date: controller.loadedBoardModels[index].date!,
                      onLoad: () {
                        controller
                            .loadBoard(controller.loadedBoardModels[index].id!);
                      },
                      
                      id: controller.loadedBoardModels[index].id!,
                    );
                  }),
            ).animate().fade(duration: 600.ms).slideY(begin: 0.3)
          ],
        ),
      ),
    );
  }
}
