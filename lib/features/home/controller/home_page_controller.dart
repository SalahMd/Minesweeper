import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/services/game_services.dart';
import 'package:untitled/features/home/data/board.dart';

class HomePageController extends GetxController {
  int numOfMines = 10, numOfRows = 9, numOfColumns = 8, numOfCells = 72;
  late Timer timer;
  final BuildContext context;
  GameServices gameServices = GameServices();
  List<Board> boards = [];
  HomePageController({required this.context});

  @override
  void onInit() async {
    if (await Get.arguments != null) {
      boards.add(await Get.arguments);
      startTimer(await Get.arguments, false);
      update();
    } else {
      initBoard(false);
    }
    super.onInit();
  }

  void initBoard(bool replay, {Board? board}) {
    if (replay) {
      boards.last.replay(board!);
      startTimer(board, true);
    } else {
      boards.add(Board.generateBoard(
          numOfBoards: boards.length + 1,
          numOfRows: numOfRows,
          numOfColumns: numOfColumns,
          numOfCells: numOfCells));
      boards.last.minesDistribution(boards.last);
      startTimer(boards.last, false);
    }
    update();
  }

  void startTimer(Board board, bool replay) {
    if (!replay) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!board.isLost && !board.isWin) {
          if (board.seconds == 300) {
            checkLose(board, isTimed: true);
          }
          board.seconds++;
          update();
        }
      });
    }
  }

  void onTapButton(int posX, int posY, Board board) {
    if (checkLose(board, x: posX, y: posY)) {
      update();
      return;
    }
    board.openCells(board, posX, posY, ctx: context);
    update();
  }

  bool checkLose(Board board, {int x = 0, int y = 0, bool isTimed = false}) {
    return board.checkLose(board, context, x: x, y: y, isTimed: isTimed);
  }

  bool checkWin(Board board) {
    return board.checkWin(board, context);
  }

  void backMove(Board board) {
    board.backMove(board);
    update();
  }

  void forwardMove(Board board) {
    board.forwardMove(board, context);
  }

  void saveBoard(int boardId) {
    gameServices.saveBoard(boards[boardId], context);
  }

  void setFlag(Board board, int posX, int posY) {
    board.setFlag(board, posX, posY);
    update();
  }
}
