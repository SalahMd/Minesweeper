import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/core/services/game_services.dart';
import 'package:untitled/features/home/model/board.dart';

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
      board!.cleanBoard(board, numOfRows, numOfColumns);
      board.minesDistribution(board, numOfRows, numOfColumns, numOfMines);
      startTimer(board, true);
    } else {
      boards
          .add(Board.generateBoard(numOfRows, numOfColumns, boards.length + 1));
      boards.last
          .minesDistribution(boards.last, numOfRows, numOfColumns, numOfMines);
      startTimer(boards.last, false);
    }
    update();
  }

  void startTimer(Board board, bool replay) {
    if (!replay) {
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        if (!board.isLost && !board.isWin) {
          if (board.seconds == 250) {
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
      return;
    }
    if (isEmptyCell(board, posX, posY)) {
      openCells(posX, posY, board);
      board.backwardMoves.add([posX, posY]);
      update();
    }
  }

  bool validCell(int i, int j) {
    return i >= 0 && j >= 0 && i < numOfRows && j < numOfColumns;
  }

  int countMines(int x, int y, Board board) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && board.mines[i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  void openCells(int x, int y, Board board) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && !board.openedCells[i][j] && !board.mines[i][j]) {
          board.openedCells[i][j] = true;
          int count = countMines(i, j, board);
          if (count == 0) {
            openCells(i, j, board);
          } else if (count != 0) {
            board.cells[i][j] = count;
          }
          board.numOfOpenedCells++;
        }
      }
    }
    checkWin(board);
  }

  void closeCells(int x, int y, Board board) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (validCell(i, j) && board.openedCells[i][j]) {
          board.openedCells[i][j] = false;
          int count = countMines(i, j, board);
          if (count == 0) {
            closeCells(i, j, board);
          } else if (count != 0) {
            board.cells[i][j] = null;
          }
          board.numOfOpenedCells--;
        }
      }
    }
    update();
  }

  bool checkLose(Board board, {int x = 0, int y = 0, bool isTimed = false}) {
    if (board.mines[x][y] || isTimed) {
      board.isLost = true;
      animationedAlert(AppAnimations.lose, 'You lost', () {
        initBoard(true, board: board);
        Get.back();
      }, context);
      update();
      return true;
    }
    return false;
  }

  bool checkWin(Board board) {
    if (board.numOfOpenedCells == numOfCells - numOfMines) {
      board.isWin = true;
      animationedAlert(AppAnimations.win, 'You won', () {
        initBoard(true, board: board);
        Get.back();
      }, context);
      update();
      return true;
    }
    return false;
  }

  void backMove(Board board) {
    if (!board.isLost && board.backwardMoves.isNotEmpty) {
      if (checkIfFlag(board, true)) {
        board.cells[board.backwardMoves.last.first]
            [board.backwardMoves.last.last] = 'ff';
      } else {
        closeCells(board.backwardMoves.last.first,
            board.backwardMoves.last.last, board);
      }
      board.forwardMoves
          .add([board.backwardMoves.last.first, board.backwardMoves.last.last]);
      board.backwardMoves.removeLast();
    }
    update();
  }

  void forwardMove(Board board) {
    if (board.forwardMoves.isNotEmpty) {
      if (checkIfFlag(board, false)) {
        setFlag(
            board, board.forwardMoves.last.first, board.forwardMoves.last.last);
      } else {
        openCells(
            board.forwardMoves.last.first, board.forwardMoves.last.last, board);
        board.backwardMoves
            .add([board.forwardMoves.last.first, board.forwardMoves.last.last]);
      }
      board.forwardMoves.removeLast();
    }
  }

  void saveBoard(int boardId) {
    gameServices.saveBoard(boards[boardId], context);
  }

  void setFlag(Board board, int posX, int posY) {
    if (isEmptyCell(board, posX, posY) && board.cells[posX][posY] != 'f') {
      board.cells[posX][posY] = "f";
      board.backwardMoves.add([posX, posY]);
    }
    update();
  }

  bool isEmptyCell(Board board, int posX, int posY) {
    return !board.openedCells[posX][posY] && !board.isLost && !board.isWin;
  }

  bool checkIfFlag(Board board, bool backMove) {
    if (!backMove) {
      return board.cells[board.forwardMoves.last.first]
              [board.forwardMoves.last.last] ==
          'ff';
    } else {
      return board.cells[board.backwardMoves.last.first]
              [board.backwardMoves.last.last] ==
          'f';
    }
  }
}
