import 'dart:convert';
import 'package:get/get.dart';
import 'package:untitled/core/helpers/shared_pref_helper.dart';
import 'package:untitled/core/services/game_services.dart';
import 'package:untitled/features/load_board/model/load_board_model.dart';

class LoadBoardController extends GetxController {
  SharedPrefHelper sharedPref = SharedPrefHelper();
  List<LoadBoardModel> loadedBoardModels = [];
  GameServices gameServices = GameServices();
  int numOfSavedBoards = 0;

  @override
  void onInit() async {
    numOfSavedBoards = await sharedPref.getInt("numOfSavedBoards")!;
    loadAllBoards();
    super.onInit();
  }

  loadAllBoards() async {
    for (int i = 1; i <= numOfSavedBoards; i++) {
      loadedBoardModels.add(LoadBoardModel(
          cells:
              json.decode(await sharedPref.getString("cells${i.toString()}")!),
          openedCells: json.decode(
              await sharedPref.getString("openedCells${i.toString()}")!),
          id: await sharedPref.getInt("id${i.toString()}")!,
          mines:
              json.decode(await sharedPref.getString("mines${i.toString()}")!),
          numOfOpenedCells:
              await sharedPref.getInt("numOfOpenedCells${i.toString()}")!,
          date: await sharedPref.getString('date${i.toString()}')));
    }
    update();
  }

  loadBoard(int boardId) {
    Get.toNamed("HomePage", arguments: gameServices.loadBoard(boardId));
  }
}
