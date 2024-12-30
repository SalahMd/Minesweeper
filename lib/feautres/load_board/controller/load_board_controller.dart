import 'dart:convert';
import 'package:get/get.dart';
import 'package:untitled/core/services/shared_pref.dart';
import 'package:untitled/feautres/load_board/model/load_board_model.dart';

class LoadBoardController extends GetxController {
  SharedPref sharedPref = Get.find();
  List<LoadBoardModel> loadedBoardModels = [];
  int numOfSavedBoards = 0;

  @override
  void onInit() async {
    numOfSavedBoards = sharedPref.sharedPreferences.getInt("numOfSavedBoards")!;

    loadAllBoards();
    super.onInit();
  }

  loadBoard(int id) async {}

  loadAllBoards() {
    for (int i = 0; i < numOfSavedBoards; i++) {
      loadedBoardModels.add(LoadBoardModel(
          cells: json.decode(sharedPref.sharedPreferences
              .getString("cells${(i + 1).toString()}")!),
          openedCells: json.decode(sharedPref.sharedPreferences
              .getString("openedCells${(i + 1).toString()}")!),
          id: sharedPref.sharedPreferences.getInt("id${(i + 1).toString()}")!,
          mines: json.decode(sharedPref.sharedPreferences
              .getString("mines${(i + 1).toString()}")!),
          numOfOpenedCells: sharedPref.sharedPreferences
              .getInt("numOfOpenedCells${(i + 1).toString()}")!,
          date: sharedPref.sharedPreferences
              .getString('date${(i + 1).toString()}')));
    }
  }
}
