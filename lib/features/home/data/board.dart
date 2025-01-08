import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/features/home/data/cells.dart';

class Board {
  int numOfMines = 10, numOfRows = 9, numOfColumns = 8, numOfCells = 72;
  List cells, openedCells, mines;
  int numOfOpenedCells;
  int id;
  int seconds;
  bool isLost;
  bool isWin;
  List backwardMoves;
  List forwardMoves;
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
    required this.numOfRows,
    required this.numOfColumns,
    required this.numOfCells,
  })  : seconds = 0,
        isLost = false,
        isWin = false,
        backwardMoves = [],
        forwardMoves = [],
        cells = generateList(null, numOfRows, numOfColumns),
        openedCells = generateList([false, 0], numOfRows, numOfColumns),
        mines = generateList(false, numOfRows, numOfColumns),
        numOfOpenedCells = 0,
        id = numOfBoards,
        flags = [],
        cell = Cells(numOfRows: numOfRows, numOfColumns: numOfColumns);

  static List generateList(var val, int numOfRows, int numOfColumns) {
    return List<List>.generate(
      numOfRows,
      (i) => List<dynamic>.generate(
        numOfColumns,
        (index) => val,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'cells': cells,
        'openedCells': openedCells,
        'mines': mines,
        'numOfOpenedCells': numOfOpenedCells,
        'seconds': seconds,
        'id': id,
        'backwardMoves': backwardMoves,
        'forwardMoves': forwardMoves,
        'flags': flags,
        'isWin': isWin,
        'isLost': isLost,
      };

  static Board fromJson(
    Map<String, dynamic> json,
  ) {
    return Board(
      json['cells'],
      json['openedCells'],
      json['mines'],
      json['numOfOpenedCells'],
      json['seconds'],
      json['id'],
      json['backwardMoves'],
      json['forwardMoves'],
      json['flags'],
      json['isWin'],
      json['isLost'],
      json['cell'],
    );
  }

  cleanBoard(Board board) {
    board.mines = List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => false,
            ));
    board.openedCells = List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => [false, backwardMoves.length],
            ));
    board.cells = List<List>.generate(
        numOfRows,
        (i) => List<dynamic>.generate(
              numOfColumns,
              (index) => null,
            ));

    board.seconds = 0;
    board.isWin = false;
    board.isLost = false;
    board.numOfOpenedCells = 0;
    board.backwardMoves = [];
    board.forwardMoves = [];
  }

  minesDistribution(
    Board board,
  ) {
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

  bool checkLose(Board board, BuildContext ctx,
      {int x = 0, int y = 0, bool isTimed = false}) {
    if (board.mines[x][y] || isTimed) {
      board.isLost = true;
      animationedAlert(AppAnimations.lose, 'You lost', () {
        replay(board);
        Get.back();
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
      int first = board.forwardMoves.last.first;
      int last = board.forwardMoves.last.last;
      if (board.cells[first][last] == 'ff') {
        cell.setFlag(board, first, last);
      } else {
        board.backwardMoves.add([first, last]);
        cell.openCells(first, last, board, ctx);
        checkWin(board, ctx);
      }
      board.forwardMoves.removeLast();
    }
  }

  void backMove(Board board) {
    if (!board.isLost && board.backwardMoves.isNotEmpty) {
      int first = board.backwardMoves.last.first;
      int last = board.backwardMoves.last.last;
      if (board.cells[first][last] == 'f') {
        board.cells[first][last] = 'ff';
      } else {
        cell.closeCells(board);
      }
      board.forwardMoves.add([first, last]);
      board.backwardMoves.removeLast();
    }
  }

  setFlag(Board board, int posX, int posY) {
    cell.setFlag(board, posX, posY);
  }

  openCells(Board board, int posX, int posY, {BuildContext? ctx}) {
    if (cell.isEmpty(board, posX, posY)) {
      board.backwardMoves.add([posX, posY]);
      cell.openCells(posX, posY, board, ctx!);
    }
  }
}
