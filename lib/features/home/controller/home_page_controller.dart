import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/features/home/data/board.dart';
import 'package:untitled/features/home/data/game.dart';

class HomePageController extends GetxController {
  final int numOfMines = 10, numOfRows = 9, numOfColumns = 8, numOfCells = 72;
  final BuildContext context;
  Game game = Game();
  late Timer timer;
  HomePageController({required this.context});

  @override
  void onInit() async {
    if (await Get.arguments != null) {
      game.addBoard(board: await Get.arguments);
      startTimer(await Get.arguments, false);
      update();
    } else {
      initBoard(false);
    }
    super.onInit();
  }

  void initBoard(bool replay, {int? boardId}) {
    if (replay) {
      game.replay(boardId!);
      update();
      startTimer(getBoard(boardId), true);
    } else {
      game.addBoard();
      startTimer(game.boards.last, false);
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
    return board.checkLose(board, context, refreshBoard,
        x: x, y: y, isTimed: isTimed);
  }

  void refreshBoard() {
    Get.back();
    update();
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
    game.save(boardId, context);
  }

  void setFlag(Board board, int posX, int posY) {
    board.setFlag(board, posX, posY);
    update();
  }

  Board getBoard(int boardId) => game.boards[boardId];
  int getBoardsLenght() => game.boards.length;
}
