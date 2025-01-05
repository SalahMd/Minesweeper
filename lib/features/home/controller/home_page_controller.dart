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
  Board? currentBoard;
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
          if (board.seconds == 300) {
            checkLose(isTimed: true);
          }
          board.seconds++;
          update();
        }
      });
    }
  }

  void onTapButton(int posX, int posY, Board board) {
    currentBoard = board;
    if (checkLose(x: posX, y: posY)) {
      return;
    }
    if (isEmptyCell(posX, posY)) {
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
          } else {
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
          } else {
            board.cells[i][j] = null;
          }
          board.numOfOpenedCells--;
        }
      }
    }
    update();
  }

  bool checkLose({int x = 0, int y = 0, bool isTimed = false}) {
    if (currentBoard!.mines[x][y] || isTimed) {
      currentBoard!.isLost = true;
      animationedAlert(AppAnimations.lose, 'You lost', () {
        initBoard(true, board: currentBoard);
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
      int first = board.backwardMoves.last.first;
      int last = board.backwardMoves.last.last;
      if (board.cells[first][last] == 'f') {
        board.cells[first][last] = 'ff';
      } else {
        closeCells(first, last, board);
      }
      board.forwardMoves.add([first, last]);
      board.backwardMoves.removeLast();
    }
    update();
  }

  void forwardMove(Board board) {
    if (board.forwardMoves.isNotEmpty) {
      int first = board.forwardMoves.last.first;
      int last = board.forwardMoves.last.last;
      if (board.cells[first][last] == 'ff') {
        setFlag(board, first, last);
      } else {
        openCells(first, last, board);
        board.backwardMoves.add([first, last]);
      }
      board.forwardMoves.removeLast();
    }
  }

  void saveBoard(int boardId) {
    gameServices.saveBoard(boards[boardId], context);
  }

  void setFlag(Board board, int posX, int posY) {
    if (isEmptyCell( posX, posY) && board.cells[posX][posY] != 'f') {
      board.cells[posX][posY] = "f";
      board.backwardMoves.add([posX, posY]);
    }
    update();
  }

  bool isEmptyCell( int posX, int posY) {
    return !currentBoard!.openedCells[posX][posY] && !currentBoard!.isLost && !currentBoard!.isWin;
  }
}
