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
      numOfOpenedCells = 0;
  Random random = Random();
  final BuildContext context;
  bool isLost = false, isWin = false, isBackMove = false;
  int seconds = 0;
  late Timer timer;
  List<List> mines = [], openedCells = [], cells = [];
  int posXLstMove = 0, posYLastMove = 0;
  HomePageController({required this.context});

  @override
  void onInit() {
    super.onInit();
    initBoard();
    startTimer();
  }

  void initBoard() {
    mines = List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => false,
            ));
    openedCells = List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => false,
            ));
    cells = List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => null,
            ));
    seconds = 0;

    minesDistribution();
    update();
  }

  startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!isLost && !isWin) {
        if (seconds == 2000) {
          checkLose(isTimed: true);
        }
        seconds++;
        update();
      }
    });
  }

  void minesDistribution() {
    int ctn = numOfMines;
    while (ctn > 0) {
      int x = random.nextInt(numOfRows - 1);
      int j = random.nextInt(numOfColumns - 1);
      if (!mines[x][j]) {
        mines[x][j] = true;
        ctn--;
      }
    }
  }

  void onTapButton(int posX, int posY) {
    if (checkLose(x: posX, y: posY)) {
      return;
    }
    if (!openedCells[posX][posY] && !isLost && !isWin) {
      posXLstMove = posX;
      posYLastMove = posY;
      openCells(posX, posY);
    }
    update();
  }

  bool valid(int i, int j) {
    return i >= 0 && j >= 0 && i < numOfRows && j < numOfColumns;
  }

  int countMines(int x, int y) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && mines[i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  void openCells(int x, int y) {
    print(posXLstMove.toString() + "," + posYLastMove.toString());
    isBackMove = false;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && !openedCells[i][j] && !mines[i][j]) {
          openedCells[i][j] = true;
          int count = countMines(i, j);
          if (count == 0) {
            openCells(i, j);
          } else if (count != 0) {
            cells[i][j] = count;
          }
          numOfOpenedCells++;
        }
      }
    }
    checkWin();
  }

  void closeCells(int x, int y) {
    isBackMove = true;

    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && openedCells[i][j]) {
          openedCells[i][j] = false;
          print(i.toString() + j.toString() + openedCells[i][j].toString());
          int count = countMines(i, j);
          if (count == 0) {
            closeCells(i, j);
          } else if (count != 0) {
            cells[i][j] = null;
          }
          numOfOpenedCells--;
        }
      }
    }

    update();
  }

  bool checkLose({int x = 0, int y = 0, bool isTimed = false}) {
    if (mines[x][y] || isTimed) {
      isLost = true;
      animationedAlertWithActions(AppAnimations.lose, 'You lost', () {
        replay();
      }, context);
      update();
      return true;
    }
    return false;
  }

  bool checkWin() {
    if (numOfOpenedCells == (numOfRows * numOfColumns) - numOfMines) {
      isWin = true;
      animationedAlertWithActions(AppAnimations.win, 'You won', () {
        replay();
      }, context);
      update();
      return true;
    }
    return false;
  }

  void replay() {
    isWin = false;
    isLost = false;
    numOfOpenedCells = 0;
    initBoard();
    Get.back();
  }

  void backMove(int x, int y) {
    if (!isBackMove) {
      closeCells(x, y);
    }
  }

  void forwardMove(int x, int y) {
    if (isBackMove) {
      openCells(x, y);
    }
  }
}
