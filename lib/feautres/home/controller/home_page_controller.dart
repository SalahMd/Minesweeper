import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/feautres/home/controller/game_services.dart';
import 'package:untitled/feautres/home/model/board_model.dart';

class HomePageController extends GetxController {
  int numOfMines = 10,
      numOfRows = 9,
      numOfColumns = 8,
      numOfCells = 72,
      numOfBoards = 1;
  Random random = Random();
  final BuildContext context;
  GameServices gameServices = GameServices();
  late Timer timer;
  List<BoardModel> boards = [];
  HomePageController({required this.context});

  @override
  void onInit() {
    super.onInit();
    initBoard(0, false);
  }

  void initBoard(int boardId, bool replay) {
    boards.add(BoardModel(
        0,
        false,
        false,
        [],
        [],
        [],
        [],
        List<List>.generate(
            numOfRows,
            (i) => List<dynamic>.generate(
                  numOfColumns,
                  (index) => null,
                )),
        List<List>.generate(
            numOfRows,
            (i) => List<dynamic>.generate(
                  numOfColumns,
                  (index) => false,
                )),
        List<List>.generate(
            numOfRows,
            (i) => List<dynamic>.generate(
                  numOfColumns,
                  (index) => false,
                )),
        0,
        boardId));

    if (replay) {
      boards[boardId].mines = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => false,
              ));
      boards[boardId].openedCells = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => false,
              ));
      boards[boardId].cells = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => null,
              ));
      replay = false;
      boards[boardId].seconds = 1;
    }
    minesDistribution(boardId);
    startTimer(boardId);
    update();
  }

  startTimer(int boardId) {
    if (boards[boardId].seconds == 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!boards[boardId].isLost! && !boards[boardId].isWin!) {
          if (boards[boardId].seconds == 2000) {
            checkLose(boardId, isTimed: true);
          }
          boards[boardId].seconds++;
          update();
        }
      });
    }
  }

  void minesDistribution(int boardId) {
    int ctn = numOfMines;
    while (ctn > 0) {
      int x = random.nextInt(numOfRows - 1);
      int j = random.nextInt(numOfColumns - 1);
      if (!boards[boardId].mines![x][j]) {
        boards[boardId].mines![x][j] = true;
        ctn--;
      }
    }
  }

  void onTapButton(int posX, int posY, int boardId) {
    if (checkLose(boardId, x: posX, y: posY)) {
      return;
    }
    if (isEmptyCell(boardId, posX, posY)) {
      openCells(posX, posY, boardId);
      fillMovesList(boards[boardId], posX, posY);
    }

    update();
  }

  bool validCell(int i, int j) {
    return i >= 0 && j >= 0 && i < numOfRows && j < numOfColumns;
  }

  int countMines(int x, int y, int boardId) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && boards[boardId].mines![i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  void openCells(int x, int y, int boardId) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) &&
            !boards[boardId].openedCells![i][j] &&
            !boards[boardId].mines![i][j]) {
          boards[boardId].openedCells![i][j] = true;
          int count = countMines(i, j, boardId);
          if (count == 0) {
            openCells(i, j, boardId);
          } else if (count != 0) {
            boards[boardId].cells![i][j] = count;
          }
          boards[boardId].numOfOpenedCells =
              boards[boardId].numOfOpenedCells! + 1;
        }
      }
    }
    checkWin(boardId);
  }

  void closeCells(int x, int y, int boardId) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && boards[boardId].openedCells![i][j]) {
          boards[boardId].openedCells![i][j] = false;
          int count = countMines(i, j, boardId);
          if (count == 0) {
            closeCells(i, j, boardId);
          } else if (count != 0) {
            boards[boardId].cells![i][j] = null;
          }
          boards[boardId].numOfOpenedCells !=
              boards[boardId].numOfOpenedCells! - 1;
        }
      }
    }
    update();
  }

  bool checkLose(int boardId, {int x = 0, int y = 0, bool isTimed = false}) {
    if (boards[boardId].mines![x][y] || isTimed) {
      boards[boardId].isLost = true;
      animationedAlertWithActions(AppAnimations.lose, 'You lost', () {
        replay(boardId);
        Get.back();
      }, context);

      update();
      return true;
    }
    return false;
  }

  bool checkWin(int boardId) {
    if (boards[boardId].numOfOpenedCells ==
        (numOfRows * numOfColumns) - numOfMines) {
      boards[boardId].isWin = true;
      animationedAlertWithActions(AppAnimations.win, 'You won', () {
        replay(boardId);
        Get.back();
      }, context);
      update();
      return true;
    }
    return false;
  }

  void replay(int boardId) {
    boards[boardId].isWin = false;
    boards[boardId].isLost = false;
    boards[boardId].numOfOpenedCells = 0;
    initBoard(boardId, true);
  }

  void backMove(
    int boardId,
  ) {
    if (!boards[boardId].isLost! &&
        boards[boardId].numOfOpenedCells! > 0 &&
        boards[boardId].yBackMoves!.isNotEmpty) {
      closeCells(boards[boardId].xBackMoves!.last,
          boards[boardId].yBackMoves!.last, boardId);
      boards[boardId].xForwardMoves!.add(boards[boardId].xBackMoves!.last);
      boards[boardId].yForwardMoves!.add(boards[boardId].yBackMoves!.last);
      boards[boardId].xBackMoves!.removeLast();
      boards[boardId].yBackMoves!.removeLast();
    }
  }

  fillMovesList(BoardModel board, var valX, var valY,
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

  void forwardMove(int boardId) {
    if (boards[boardId].yForwardMoves!.isNotEmpty) {
      openCells(boards[boardId].xForwardMoves!.last,
          boards[boardId].yForwardMoves!.last, boardId);
      fillMovesList(boards[boardId], boards[boardId].xForwardMoves!.last,
          boards[boardId].yForwardMoves!.last,
          fillForwardMoves: false);
    }
  }

  void addBoard(int boardId) {
    numOfBoards++;
    initBoard(boardId + 1, false);
    update();
  }

  saveBoard(int boardId) {
    gameServices.saveBoard(boards[boardId], context);
  }

  setFlag(int boardId, int posX, int posY) {
    if (isEmptyCell(boardId, posX, posY) &&
        boards[boardId].cells![posX][posY] != 'f') {
      boards[boardId].cells![posX][posY] = "f";
      fillMovesList(boards[boardId], 'f', 'f');
    }
    update();
  }

  bool isEmptyCell(int boardId, int posX, int posY) {
    return !boards[boardId].openedCells![posX][posY] &&
        !boards[boardId].isLost! &&
        !boards[boardId].isWin!;
  }
}
