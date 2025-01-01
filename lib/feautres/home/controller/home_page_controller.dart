import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/core/services/game_services.dart';
import 'package:untitled/feautres/home/model/board.dart';

class HomePageController extends GetxController {
  int numOfMines = 10, numOfRows = 9, numOfColumns = 8, numOfCells = 72;
  Random random = Random();
  late Timer timer;
  final BuildContext context;
  GameServices gameServices = Get.find();
  List<Board> boards = [];
  HomePageController({required this.context});

  @override
  void onInit() {
    if (Get.arguments != null) {
      boards.add(Get.arguments);
      startTimer(Get.arguments);
      update();
    } else {
      initBoard(
        false,
      );
    }
    super.onInit();
  }

  void initBoard(bool replay, {Board? board}) {
    if (replay) {
      board!.cleanBoard(board, numOfRows, numOfColumns);
      minesDistribution(board);
      startTimer(board);
    } else {
      boards
          .add(Board.generateBoard(numOfRows, numOfColumns, boards.length + 1));
      minesDistribution(boards.last);
      startTimer(boards.last);
    }
    update();
  }

  void startTimer(Board board) {
    if (board.seconds == 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!board.isLost! && !board.isWin!) {
          if (board.seconds == 200) {
            checkLose(board, isTimed: true);
          }
          board.seconds++;
          update();
        }
      });
    }
  }

  void minesDistribution(Board board) {
    int ctn = numOfMines;
    while (ctn > 0) {
      int x = random.nextInt(numOfRows - 1);
      int j = random.nextInt(numOfColumns - 1);
      if (!board.mines![x][j]) {
        board.mines![x][j] = true;
        ctn--;
      }
    }
  }

  void onTapButton(int posX, int posY, Board board) {
    if (checkLose(board, x: posX, y: posY)) {
      return;
    }
    if (isEmptyCell(board, posX, posY)) {
      openCells(posX, posY, board);
      fillMovesList(board, posX, posY);
    }
    update();
  }

  bool validCell(int posX, int posY) {
    return posX >= 0 && posY >= 0 && posX < numOfRows && posY < numOfColumns;
  }

  int countMines(int x, int y, Board board) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && board.mines![i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  void openCells(int x, int y, Board board) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) &&
            !board.openedCells![i][j] &&
            !board.mines![i][j]) {
          board.openedCells![i][j] = true;
          int count = countMines(i, j, board);
          if (count == 0) {
            openCells(i, j, board);
          } else if (count != 0) {
            board.cells![i][j] = count;
          }
          board.numOfOpenedCells = board.numOfOpenedCells! + 1;
        }
      }
    }
    checkWin(board);
  }

  void closeCells(int x, int y, Board board) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && board.openedCells![i][j]) {
          board.openedCells![i][j] = false;
          int count = countMines(i, j, board);
          if (count == 0) {
            closeCells(i, j, board);
          } else if (count != 0) {
            board.cells![i][j] = null;
          }
          board.numOfOpenedCells != board.numOfOpenedCells! - 1;
        }
      }
    }
    update();
  }

  bool checkLose(Board board, {int x = 0, int y = 0, bool isTimed = false}) {
    if (board.mines![x][y] || isTimed) {
      board.isLost = true;
      animationedAlertWithActions(AppAnimations.lose, 'You lost', () {
        initBoard(true, board: board);
        Get.back();
      }, context);
      update();
      return true;
    }
    return false;
  }

  bool checkWin(Board board) {
    if (board.numOfOpenedCells == (numOfRows * numOfColumns) - numOfMines) {
      board.isWin = true;
      animationedAlertWithActions(AppAnimations.win, 'You won', () {
        initBoard(true, board: board);
        Get.back();
      }, context);
      update();
      return true;
    }
    return false;
  }

  void backMove(Board board) {
    if (!board.isLost! &&
        board.numOfOpenedCells! > 0 &&
        board.yBackMoves!.isNotEmpty) {
      closeCells(board.xBackMoves!.last, board.yBackMoves!.last, board);
      board.xForwardMoves!.add(board.xBackMoves!.last);
      board.yForwardMoves!.add(board.yBackMoves!.last);
      board.xBackMoves!.removeLast();
      board.yBackMoves!.removeLast();
    }
  }

  fillMovesList(Board board, var valX, var valY,
      {bool fillForwardMoves = true}) {
    board.xBackMoves!.add(valX);
    board.yBackMoves!.add(valY);
    if (fillForwardMoves) {
      board.xForwardMoves!.add(valX);
      board.yForwardMoves!.add(valY);
    } else {
      board.xForwardMoves!.removeLast();
      board.yForwardMoves!.removeLast();
    }
  }

  void forwardMove(Board board) {
    if (board.yForwardMoves!.isNotEmpty) {
      openCells(board.xForwardMoves!.last, board.yForwardMoves!.last, board);
      fillMovesList(board, board.xForwardMoves!.last, board.yForwardMoves!.last,
          fillForwardMoves: false);
    }
  }

  saveBoard(int boardId) {
    gameServices.saveBoard(boards[boardId], context);
  }

  setFlag(Board board, int posX, int posY) {
    if (isEmptyCell(board, posX, posY) && board.cells![posX][posY] != 'f') {
      board.cells![posX][posY] = "f";
      fillMovesList(board, 'f', 'f');
    }
    update();
  }

  bool isEmptyCell(Board board, int posX, int posY) {
    return !board.openedCells![posX][posY] && !board.isLost! && !board.isWin!;
  }
}