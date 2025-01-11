import 'package:flutter/material.dart';
import 'package:untitled/core/services/game_services.dart';

import 'board.dart';

class Game {
  List<Board> boards = [];
  GameServices gameServices = GameServices();
  Board getBoard(int boardId) {
    return boards[boardId];
  }

  addBoard({Board? board}) {
    if (board != null) {
      boards.add(board);
    } else {
      boards.add(Board.generateBoard(numOfBoards: boards.length + 1));
      distrubuteMines(boards.last);
    }
  }

  void distrubuteMines(Board board) {
    board.minesDistribution(board);
  }

  void replay(int boardId) {
    boards[boardId].replay(boards[boardId]);
  }

  void save(int boardId, BuildContext ctx) {
    gameServices.saveBoard(getBoard(boardId), ctx);
  }


}
