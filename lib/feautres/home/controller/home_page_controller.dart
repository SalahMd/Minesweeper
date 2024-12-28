import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';

class HomePageController extends GetxController {
  int numOfMines = 10, numOfRows = 9, numOfColumns = 8, numOfOpenedCells = 0;
  Random random = Random();
  final BuildContext context;
  bool isLost = false;
  int seconds = 0, t = 0;
  late Timer timer;
  List<List> mines = [], openedCells = [], cells = [];

  HomePageController({required this.context});

  @override
  void onInit() {
    super.onInit();
    initBoard();
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

    minesDistribution();
    update();
    //startTimer();
  }

  // startTimer() {
  //   seconds = 0;
  //   timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
  //     seconds++;
  //   });

  //   update();
  // }

  void minesDistribution() {
    int ctn = numOfMines;
    while (ctn > 0) {
      int x = random.nextInt(numOfRows - 1);
      int j = random.nextInt(numOfColumns - 1);
      print(x.toString() + "," + j.toString());
      if (!mines[x][j]) {
        mines[x][j] = true;
        ctn--;
      }
    }
  }

  void onTapButton(int x, int y) {
    if (checkLose(x, y)) {
      return;
    }
    if (!openedCells[x][y]) {
      floodFill(x, y);
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
    print(ctn);
    return ctn;
  }

  void floodFill(int x, int y) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && !openedCells[i][j] && !mines[i][j]) {
          openedCells[i][j] = true;
          int count = countMines(i, j);
          if (count == 0) {
            floodFill(i, j);
          } else if (count != 0) {
            cells[i][j] = count;
          }
          numOfOpenedCells++;
        }
      }
    }
    checkWin();
  }

  bool checkLose(int x, int y) {
    if (mines[x][y]) {
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
    print(numOfOpenedCells);
    if (numOfOpenedCells == (numOfRows * numOfColumns) - numOfMines) {
      animationedAlertWithActions(AppAnimations.win, 'You won', () {
        replay();
      }, context);
      update();
      return true;
    }
    return false;
  }

  replay() {
    isLost = false;
    numOfOpenedCells = 0;
    Get.back();
    initBoard();
  }
}
