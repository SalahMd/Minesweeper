import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/core/services/shared_pref.dart';
import 'package:untitled/feautres/home/model/board.dart';

class GameServices {
  SharedPref sharedPref = Get.find();

  void saveBoard(Board boards, BuildContext context) async {
    int ctn;
    if (sharedPref.sharedPreferences.getInt('numOfSavedBoards') == null) {
      ctn = 0;
      sharedPref.sharedPreferences.setInt('numOfSavedBoards', ctn);
    }
    ctn = sharedPref.sharedPreferences.getInt('numOfSavedBoards')! + 1;

    await sharedPref.sharedPreferences.setInt('numOfSavedBoards', ctn);
    await sharedPref.sharedPreferences.setInt('id${ctn.toString()}', ctn);
    await sharedPref.sharedPreferences
        .setInt('numOfOpenedCells${ctn.toString()}', boards.numOfOpenedCells!);
    await sharedPref.sharedPreferences
        .setString('cells${ctn.toString()}', json.encode(boards.cells));
    await sharedPref.sharedPreferences
        .setString('mines${ctn.toString()}', json.encode(boards.mines));
    await sharedPref.sharedPreferences.setString(
        'openedCells${ctn.toString()}', json.encode(boards.openedCells));
    await sharedPref.sharedPreferences
        .setString('date${ctn.toString()}', DateTime.now().toString());
    animationedAlertWithActions(AppAnimations.done, "Board is saved", () {
      Get.back();
    // ignore: use_build_context_synchronously
    }, context, icon: Icons.arrow_back);
  }

  Board loadBoard(int boardId)  {
    Board board = Board(
        0,
        false,
        false,
        [],
        [],
        [],
        [],
        json.decode(sharedPref.sharedPreferences
            .getString("cells${boardId.toString()}")!),
        json.decode(sharedPref.sharedPreferences
            .getString("openedCells${boardId.toString()}")!),
        json.decode(sharedPref.sharedPreferences
            .getString("mines${boardId.toString()}")!),
        sharedPref.sharedPreferences
            .getInt("numOfOpenedCells${boardId.toString()}")!,
        sharedPref.sharedPreferences.getInt("id${boardId.toString()}")!);
    return board;
  }
}
