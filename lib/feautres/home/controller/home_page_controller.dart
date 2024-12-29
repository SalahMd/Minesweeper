import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';

class HomePageController extends GetxController {
  int numOfMines = 10,
      numOfRows = 9,
      numOfColumns = 8,
      numOfCells = 72,
      numOfBoards = 1;
  Random random = Random();
  final BuildContext context;
  List<bool> isLost = [false], isWin = [false], isBackMove = [false];
  List<int> seconds = [], numOfOpenedCells = [];
  List<Timer> timer = [];
  List<List<List>> mines = [], openedCells = [], cells = [];
  List<int> posXLstMove = [0], posYLastMove = [0];
  HomePageController({required this.context});

  @override
  void onInit() {
    super.onInit();
    initBoard(0, false);
  }

  void initBoard(int numOfBoard, bool replay) {
    seconds.add(numOfBoard);
    posXLstMove.add(0);
    posYLastMove.add(0);
    numOfOpenedCells.add(1);
    if (replay) {
      mines[numOfBoard] = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => false,
              ));
      openedCells[numOfBoard] = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => false,
              ));
      cells[numOfBoard] = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => null,
              ));
      replay = false;
    }
    mines.add(List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => false,
            )));
    openedCells.add(List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => false,
            )));
    cells.add(List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => null,
            )));
    //timer.add(Timer(duration, callback));
    print(mines.length);
    isLost.add(false);
    isWin.add(false);
    isBackMove.add(false);
    minesDistribution(numOfBoard);
    // startTimer(numOfBoard);

    update();
  }

  startTimer(int boardNum) {
    if (seconds[boardNum] == 0) {
      timer[boardNum] = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!isLost[boardNum] && !isWin[boardNum]) {
          if (seconds[boardNum] == 2000) {
            checkLose(boardNum, isTimed: true);
          }
          seconds[boardNum]++;
          update();
        }
      });
    }
  }

  void minesDistribution(int numOfBoard) {
    int ctn = numOfMines;
    while (ctn > 0) {
      int x = random.nextInt(numOfRows - 1);
      int j = random.nextInt(numOfColumns - 1);
      if (!mines[numOfBoard][x][j]) {
        mines[numOfBoard][x][j] = true;
        ctn--;
      }
    }
  }

  void onTapButton(int posX, int posY, int numOfBoard) {
    if (checkLose(numOfBoard, x: posX, y: posY)) {
      return;
    }
    if (!openedCells[numOfBoard][posX][posY] &&
        !isLost[numOfBoard] &&
        !isWin[numOfBoard]) {
      posXLstMove[numOfBoard] = posX;
      posYLastMove[numOfBoard] = posY;
      openCells(posX, posY, numOfBoard);
    }
    update();
  }

  bool valid(int i, int j) {
    return i >= 0 && j >= 0 && i < numOfRows && j < numOfColumns;
  }

  int countMines(int x, int y, int numOfBoard) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && mines[numOfBoard][i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  void openCells(int x, int y, int boardNum) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) &&
            !openedCells[boardNum][i][j] &&
            !mines[boardNum][i][j]) {
          openedCells[boardNum][i][j] = true;
          int count = countMines(i, j, boardNum);
          if (count == 0) {
            openCells(i, j, boardNum);
          } else if (count != 0) {
            cells[boardNum][i][j] = count;
          }
          numOfOpenedCells[boardNum]++;
        }
      }
    }
    checkWin(boardNum);
  }

  void closeCells(int x, int y, int numOfBoard) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && openedCells[numOfBoard][i][j]) {
          openedCells[numOfBoard][i][j] = false;
          print(i.toString() +
              j.toString() +
              openedCells[numOfBoard][i][j].toString());
          int count = countMines(i, j, numOfBoard);
          if (count == 0) {
            closeCells(i, j, numOfBoard);
          } else if (count != 0) {
            cells[numOfBoard][i][j] = null;
          }
          numOfOpenedCells[numOfBoard]--;
        }
      }
    }

    update();
  }

  bool checkLose(int numOfBoard, {int x = 0, int y = 0, bool isTimed = false}) {
    if (mines[numOfBoard][x][y] || isTimed) {
      isLost[numOfBoard] = true;
      animationedAlertWithActions(AppAnimations.lose, 'You lost', () {
        replay(numOfBoard);
      }, context);
      update();
      return true;
    }
    return false;
  }

  bool checkWin(int numOfBoard) {
    if (numOfOpenedCells[numOfBoard] == (numOfRows * numOfColumns) - numOfMines) {
      isWin[numOfBoard] = true;
      animationedAlertWithActions(AppAnimations.win, 'You won', () {
        replay(numOfBoard);
      }, context);
      update();
      return true;
    }
    return false;
  }

  void replay(int numOfBoard) {
    print(numOfBoard.toString() + "qqqqqq");
    isWin[numOfBoard] = false;
    isLost[numOfBoard] = false;
    numOfOpenedCells[numOfBoard] = 0;
    initBoard(numOfBoard, true);
    Get.back();
  }

  void backMove(int x, int y, int numOfBoard) {
    if (!isLost[numOfBoard] && numOfOpenedCells[numOfBoard] > 0) {
      closeCells(x, y, numOfBoard);
    }
  }

  void forwardMove(int x, int y, int numOfBoard) {
    if (isBackMove[numOfBoard]) {
      openCells(x, y, numOfBoard);
    }
  }

  void addBoard(int numOfBoard) {
    numOfBoards++;
    initBoard(numOfBoard + 1, false);
    update();
  }
}
