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
}
