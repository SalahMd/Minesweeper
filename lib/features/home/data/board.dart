import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/core/helpers/stack.dart';
import 'package:untitled/features/home/data/cells.dart';

class Board {
  static int numOfMines = 10, numOfRows = 9, numOfColumns = 8, numOfCells = 72;
  List cells, openedCells, mines;
  int numOfOpenedCells;
  int id;
  int seconds;
  bool isLost;
  bool isWin;
  MyStack backwardMoves;
  MyStack forwardMoves;
  List flags;
  Cells cell;
  Board(
      this.seconds,
      this.isLost,
      this.isWin,
      this.backwardMoves,
      this.forwardMoves,
      this.cells,
      this.openedCells,
      this.mines,
      this.numOfOpenedCells,
      this.id,
      this.flags,
      this.cell);

  Board.generateBoard({
    required int numOfBoards,
  })  : seconds = 0,
        isLost = false,
        isWin = false,
        backwardMoves =MyStack(),
        forwardMoves =MyStack(),
        cells = generateList(null),
        openedCells = generateList([false, 0]),
        mines = generateList(false),
        numOfOpenedCells = 0,
        id = numOfBoards,
        flags = [],
        cell = Cells(numOfRows: numOfRows, numOfColumns: numOfColumns);

  static List generateList(var val) {
    return List<List>.generate(
      numOfRows,
      (i) => List<dynamic>.generate(
        numOfColumns,
        (index) => val,
      ),
    );
  }

  cleanBoard(Board board) {
    board.mines = generateList(false);
    board.openedCells = generateList([false, backwardMoves.length]);
    board.cells = generateList(null);
    board.seconds = 0;
    board.isWin = false;
    board.isLost = false;
    board.numOfOpenedCells = 0;
    board.backwardMoves.clear();
    board.forwardMoves .clear();
  }

  minesDistribution(Board board) {
    Random random = Random();
    int ctn = numOfMines;
    while (ctn > 0) {
      int x = random.nextInt(numOfRows - 1);
      int j = random.nextInt(numOfColumns - 1);
      if (!board.mines[x][j]) {
        board.mines[x][j] = true;
        ctn--;
      }
    }
  }

  bool checkLose(Board board, BuildContext ctx, void Function() refresh,
      {int? x, int? y, bool isTimed = false}) {
    if (board.mines[x!][y!] || isTimed) {
      board.isLost = true;
      animationedAlert(AppAnimations.lose, 'You lost', () {
        replay(board);
        refresh();
      }, ctx);
      return true;
    }
    return false;
  }

  bool checkWin(Board board, BuildContext ctx) {
    if (board.numOfOpenedCells == numOfCells - numOfMines) {
      board.isWin = true;
      animationedAlert(AppAnimations.win, 'You won', () {
        replay(board);
        Get.back();
      }, ctx);
      return true;
    }
    return false;
  }

  void replay(Board board) {
    board.cleanBoard(board);
    board.minesDistribution(board);
  }

  void forwardMove(Board board, BuildContext ctx) {
    if (board.forwardMoves.isNotEmpty) {
      int first = board.forwardMoves.peek.first;
      int last = board.forwardMoves.peek.last;
      if (board.cells[first][last] == 'ff') {
        cell.setFlag(board, first, last);
      } else {
        board.backwardMoves.push([first, last]);
        cell.openCells(first, last, board, ctx);
        checkWin(board, ctx);
      }
      board.forwardMoves.pop();
    }
  }

  void backMove(Board board) {
    if (!board.isLost && board.backwardMoves.isNotEmpty) {
      int first = board.backwardMoves.peek.first;
      int last = board.backwardMoves.peek.last;
      if (board.cells[first][last] == 'f') {
        board.cells[first][last] = 'ff';
      } else {
        cell.closeCells(board);
      }
      board.forwardMoves.push([first, last]);
      board.backwardMoves.pop();
    }
  }

  setFlag(Board board, int posX, int posY) {
    cell.setFlag(board, posX, posY);
  }

  openCells(Board board, int posX, int posY, {BuildContext? ctx}) {
    if (cell.isEmpty(board, posX, posY)) {
      board.backwardMoves.push([posX, posY]);
      cell.openCells(posX, posY, board, ctx!);
    }
  }
}
