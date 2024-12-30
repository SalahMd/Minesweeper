class LoadBoardModel {
  List? cells, openedCells, mines;
  int? numOfOpenedCells;
  int? id;
  String? date;

  LoadBoardModel(
      {this.cells,
      this.openedCells,
      this.mines,
      this.numOfOpenedCells,
      this.date,
      this.id});
}
