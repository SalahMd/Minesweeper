import 'package:flutter/material.dart';
import 'package:untitled/features/home/data/board.dart';

class Cells {
  final int numOfRows, numOfColumns;

  Cells({required this.numOfRows, required this.numOfColumns});

  void closeCells(Board board) {
    for (int j = 0; j < numOfRows; j++) {
      for (int i = 0; i < numOfColumns; i++) {
        if (board.openedCells[j][i].last == board.backwardMoves.length &&
            board.openedCells[j][i].first) {
          board.cells[j][i] = null;
          board.openedCells[j][i].first = false;
          board.openedCells[j][i].last = 0;
          board.numOfOpenedCells--;
        }
      }
    }
  }

  void openCells(int x, int y, Board board, BuildContext ctx) {
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) &&
            !board.openedCells[i][j].first &&
            !board.mines[i][j]) {
          board.openedCells[i][j] = [true, board.backwardMoves.length];
          int count = countMines(i, j, board);
          if (count == 0) {
            openCells(i, j, board, ctx);
          } else {
            board.cells[i][j] = count;
          }
          board.numOfOpenedCells++;
        }
      }
    }
      board.checkWin(board, ctx);
  }

  int countMines(int x, int y, Board board) {
    int ctn = 0;
    for (int i = x - 1; i <= x + 1; i++) {
      for (int j = y - 1; j <= y + 1; j++) {
        if (valid(i, j) && board.mines[i][j]) {
          ctn++;
        }
      }
    }
    return ctn;
  }

  bool valid(int i, int j) {
    return i >= 0 && j >= 0 && i < numOfRows && j < numOfColumns;
  }

  void setFlag(Board board, int posX, int posY) {
    if (isEmpty(board, posX, posY) && board.cells[posX][posY] != 'f') {
      board.cells[posX][posY] = "f";
      board.backwardMoves.push([posX, posY]);
    }
  }

  bool isEmpty(Board board, int posX, int posY) {
    return !board.openedCells[posX][posY].first &&
        !board.isLost &&
        !board.isWin;
  }
}
