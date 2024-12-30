import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/core/services/shared_pref.dart';

class HomePageController extends GetxController {
  int numOfMines = 10,
      numOfRows = 9,
      numOfColumns = 8,
      numOfCells = 72,
      numOfBoards = 1;
  Random random = Random();
  final BuildContext context;
  List<bool> isLost = [false], isWin = [false];
  List<int> seconds = [0], numOfOpenedCells = [0];
  late Timer timer;
  List<List<List>> mines = [], openedCells = [], cells = [];
  List<List> xBackMoves = [],
      yBackMoves = [],
      xForwardMoves = [],
      yForwardMoves = [];
  SharedPref sharedPref = Get.find();
  HomePageController({required this.context});

  @override
  void onInit() {
    super.onInit();
    initBoard(0, false);
  }

  void initBoard(int boardId, bool replay) {
    seconds.add(0);
    seconds[boardId] = 0;
    xBackMoves.add([]);
    yBackMoves.add([]);
    xForwardMoves.add([]);
    yForwardMoves.add([]);
    numOfOpenedCells.add(1);
    if (replay) {
      mines[boardId] = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => false,
              ));
      openedCells[boardId] = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => false,
              ));
      cells[boardId] = List<List>.generate(
          numOfRows,
          (i) => List<dynamic>.generate(
                numOfColumns,
                (index) => null,
              ));
      replay = false;
      seconds[boardId] = 1;
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
    isLost.add(false);
    isWin.add(false);
    minesDistribution(boardId);
    startTimer(boardId);
    update();
  }

  startTimer(int boardId) {
    if (seconds[boardId] == 0) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!isLost[boardId] && !isWin[boardId]) {
          if (seconds[boardId] == 2000) {
            checkLose(boardId, isTimed: true);
          }
          seconds[boardId]++;
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
      if (!mines[boardId][x][j]) {
        mines[boardId][x][j] = true;
        ctn--;
      }
    }
  }

  void onTapButton(int posX, int posY, int boardId) {
    if (checkLose(boardId, x: posX, y: posY)) {
      return;
    }
    if (!openedCells[boardId][posX][posY] &&
        !isLost[boardId] &&
        !isWin[boardId]) {
      openCells(posX, posY, boardId);
      xBackMoves[boardId].add(posX);
      yBackMoves[boardId].add(posY);
      xForwardMoves[boardId].add(posX);
      yForwardMoves[boardId].add(posY);
    }

    update();
  }

  bool valid(int i, int j) {
    return i >= 0 && j >= 0 && i < numOfRows && j < numOfColumns;
  }

  int countMines(int x, int y, int boardId) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && mines[boardId][i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  void openCells(int x, int y, int boardId) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) &&
            !openedCells[boardId][i][j] &&
            !mines[boardId][i][j]) {
          openedCells[boardId][i][j] = true;
          int count = countMines(i, j, boardId);
          if (count == 0) {
            openCells(i, j, boardId);
          } else if (count != 0) {
            cells[boardId][i][j] = count;
          }
          numOfOpenedCells[boardId]++;
        }
      }
    }
    checkWin(boardId);
  }

  void closeCells(int x, int y, int boadId) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && openedCells[boadId][i][j]) {
          openedCells[boadId][i][j] = false;
          int count = countMines(i, j, boadId);
          if (count == 0) {
            closeCells(i, j, boadId);
          } else if (count != 0) {
            cells[boadId][i][j] = null;
          }
          numOfOpenedCells[boadId]--;
        }
      }
    }
    update();
  }

  bool checkLose(int boardId, {int x = 0, int y = 0, bool isTimed = false}) {
    if (mines[boardId][x][y] || isTimed) {
      isLost[boardId] = true;
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
    if (numOfOpenedCells[boardId] == (numOfRows * numOfColumns) - numOfMines) {
      isWin[boardId] = true;
      animationedAlertWithActions(AppAnimations.win, 'You won', () {
        replay(boardId);
      }, context);
      update();
      return true;
    }
    return false;
  }

  void replay(int boardId) {
    isWin[boardId] = false;
    isLost[boardId] = false;
    numOfOpenedCells[boardId] = 0;
    initBoard(boardId, true);
  }

  void backMove(int boardId) {
    if (!isLost[boardId] &&
        numOfOpenedCells[boardId] > 0 &&
        yBackMoves[boardId].isNotEmpty) {
      closeCells(xBackMoves[boardId].last, yBackMoves[boardId].last, boardId);
      xForwardMoves[boardId].add(xBackMoves[boardId].last);
      yForwardMoves[boardId].add(yBackMoves[boardId].last);
      xBackMoves[boardId].removeLast();
      yBackMoves[boardId].removeLast();
    }
  }

  void forwardMove(int boardId) {
    if (yForwardMoves[boardId].isNotEmpty) {
      openCells(
          xForwardMoves[boardId].last, yForwardMoves[boardId].last, boardId);
      xBackMoves[boardId].add(xForwardMoves[boardId].last);
      yBackMoves[boardId].add(yForwardMoves[boardId].last);
      xForwardMoves[boardId].removeLast();
      yForwardMoves[boardId].removeLast();
    }
  }

  void addBoard(int boardId) {
    numOfBoards++;
    initBoard(boardId + 1, false);
    update();
  }

  void saveBoard(int boardId) async {
    //await sharedPref.sharedPreferences.setStringList('', []);
    animationedAlertWithActions(AppAnimations.win, "Board is saved", () {
      Get.back();
    }, context);
  }

  setFlag(int boardId, int posX, int posY) {
    if (!openedCells[boardId][posX][posY] &&
        !isLost[boardId] &&
        !isWin[boardId] &&
        cells[boardId][posX][posY] != 'f') {
      cells[boardId][posX][posY] = "f";
      xBackMoves[boardId].add(posX);
      yBackMoves[boardId].add(posY);
      xForwardMoves[boardId].add(posX);
      yForwardMoves[boardId].add(posY);
    }
    update();
  }
}
