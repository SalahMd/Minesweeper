import 'dart:convert';
import 'package:get/get.dart';
import 'package:untitled/core/services/shared_pref.dart';
import 'package:untitled/feautres/home/controller/game_services.dart';
import 'package:untitled/feautres/home/view/screens/home_page.dart';
import 'package:untitled/feautres/load_board/model/load_board_model.dart';

class LoadBoardController extends GetxController {
  SharedPref sharedPref = Get.find();
  List<LoadBoardModel> loadedBoardModels = [];
  GameServices game = GameServices();
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

  deleteBoard(int id, int index) {
    sharedPref.sharedPreferences.remove('cells${id.toString()}');
    sharedPref.sharedPreferences.remove('openedCells${id.toString()}');
    sharedPref.sharedPreferences.remove('mines${id.toString()}');
    sharedPref.sharedPreferences.remove('numOfOpenedCells${id.toString()}');
    sharedPref.sharedPreferences.remove('date${id.toString()}');
    int ctn = numOfSavedBoards - 1;
    sharedPref.sharedPreferences.setInt("numOfSavedBoards", ctn);
    loadedBoardModels.removeAt(index);
    update();
  }

  loadBoard(int boardId) {
    Get.to(const HomePage(),arguments: game.loadBoard(boardId));
  }
}
