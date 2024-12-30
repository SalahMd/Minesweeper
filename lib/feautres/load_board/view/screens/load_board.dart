import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/colors.dart';
import 'package:untitled/feautres/home/view/widgets/top_bar.dart';
import 'package:untitled/feautres/load_board/controller/load_board_controller.dart';
import 'package:untitled/feautres/load_board/view/widgets/load_board_widget.dart';

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
                  itemCount: controller.numOfSavedBoards,
                  itemBuilder: (context, index) {
                    return LoadBoardWidget(
                      boardName: 'Saved board',
                      date: controller.loadedBoardModels[index].date!,
                      onLoad: () {
                     //   controller.loadBoard(index);
                      },
                      onRemove: () {},
                      id: controller.loadedBoardModels[index].id!,
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
