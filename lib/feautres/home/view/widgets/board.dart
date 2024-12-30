import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:untitled/feautres/home/controller/home_page_controller.dart';
import 'package:untitled/feautres/home/view/widgets/grid.dart';
import 'package:untitled/feautres/home/view/widgets/movements.dart';
import 'package:untitled/feautres/home/view/widgets/new_board.dart';
import 'package:untitled/feautres/home/view/widgets/timer.dart';

class Board extends StatelessWidget {
  final HomePageController controller;
  final int boardNum;
  const Board({super.key, required this.controller, required this.boardNum});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Timer(
          numOfMines: controller.numOfMines,
          controller: controller,
          numOfBoard: boardNum,
        ),
        Grid(
          numOfCells: controller.numOfCells,
          controller: controller,
          numOfColumns: controller.numOfColumns,
          boardNum: boardNum,
        ),
        SizedBox(
          height: 20.h,
        ),
        Movements(
          onBackMove: () {
            controller.backMove(boardNum);
          },
          onForwardMove: () {
            controller.forwardMove(boardNum);
          },
          onSaveBoard: () {
            controller.saveBoard(boardNum);
          },
        ),
        SizedBox(height: 10.h),
        NewBoard(
          onNewBoard: () {
            controller.addBoard(controller.numOfBoards - 1);
          },
        )
      ],
    );
  }
}
