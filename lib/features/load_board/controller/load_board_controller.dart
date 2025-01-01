import 'dart:convert';
import 'package:get/get.dart';
import 'package:untitled/core/services/shared_pref.dart';
import 'package:untitled/core/services/game_services.dart';
import 'package:untitled/features/load_board/model/load_board_model.dart';

class LoadBoardController extends GetxController {
  SharedPref sharedPref = Get.find();
  List<LoadBoardModel> loadedBoardModels = [];
  GameServices gameServices =GameServices();
  int numOfSavedBoards = 0;

  @override
  void onInit() async {
    numOfSavedBoards = sharedPref.sharedPreferences.getInt("numOfSavedBoards")!;
    loadAllBoards();
    super.onInit();
  }

  loadAllBoards() {
    for (int i = 1; i <= numOfSavedBoards; i++) {
      loadedBoardModels.add(LoadBoardModel(
          cells: json.decode(
              sharedPref.sharedPreferences.getString("cells${i.toString()}")!),
          openedCells: json.decode(sharedPref.sharedPreferences
              .getString("openedCells${i.toString()}")!),
          id: sharedPref.sharedPreferences.getInt("id${i.toString()}")!,
          mines: json.decode(
              sharedPref.sharedPreferences.getString("mines${i.toString()}")!),
          numOfOpenedCells: sharedPref.sharedPreferences
              .getInt("numOfOpenedCells${i.toString()}")!,
          date: sharedPref.sharedPreferences.getString('date${i.toString()}')));
    }
  }
  loadBoard(int boardId) {
    Get.toNamed("HomePage", arguments: gameServices.loadBoard(boardId));
  }
}
