class Board {
  List? cells, openedCells, mines;
  int? numOfOpenedCells;
  int? id;
  int seconds;
  bool? isLost;
  bool? isWin;
  List? xBackMoves;
  List? yBackMoves;
  List? xForwardMoves;
  List? yForwardMoves;
  Board(
      this.seconds,
      this.isLost,
      this.isWin,
      this.xBackMoves,
      this.yBackMoves,
      this.xForwardMoves,
      this.yForwardMoves,
      this.cells,
      this.openedCells,
      this.mines,
      this.numOfOpenedCells,
      this.id);
 static generateBoard(int numOfRows, int numOfColumns, int numOfBoards) {
    Board board = Board(
        0,
        false,
        false,
        [],
        [],
        [],
        [],
        List<List>.generate(
            numOfRows,
            (i) => List<dynamic>.generate(
                  numOfColumns,
                  (index) => null,
                )),
        List<List>.generate(
            numOfRows,
            (i) => List<dynamic>.generate(
                  numOfColumns,
                  (index) => false,
                )),
        List<List>.generate(
            numOfRows,
            (i) => List<dynamic>.generate(
                  numOfColumns,
                  (index) => false,
                )),
        0,
        numOfBoards);
    return board;
  }
}
