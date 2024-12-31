class BoardModel {
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
  BoardModel(
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
