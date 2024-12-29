import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/feautres/home/controller/home_page_controller.dart';
import 'package:untitled/feautres/home/view/widgets/grid.dart';
import 'package:untitled/feautres/home/view/widgets/timer.dart';
import 'package:untitled/feautres/home/view/widgets/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomePageController(context: context));
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: GetBuilder<HomePageController>(
          builder: (controller) => Column(
            children: [
              const TopBar(
                title: "Minesweeper",
              ),
              Timer(
                numOfMines: controller.numOfMines,
                controller: controller,
              ),
              Grid(
                numOfCells: controller.numOfCells,
                controller: controller,
                numOfColumns: controller.numOfColumns,
              )
            ],
          ),
        ),
      ),
    );
  }
}
