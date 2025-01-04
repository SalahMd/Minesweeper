import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/core/constants/animations.dart';
import 'package:untitled/core/helpers/alerts.dart';
import 'package:untitled/core/helpers/shared_pref_helper.dart';
import 'package:untitled/features/home/model/board.dart';

class GameServices {
  SharedPrefHelper sharedPref = SharedPrefHelper();

  void saveBoard(Board boards, BuildContext context) async {
    int ctn;
    if (await sharedPref.getInt('numOfSavedBoards') == null) {
      ctn = 0;
      await sharedPref.setData('numOfSavedBoards', ctn);
    }
    ctn = await sharedPref.getInt('numOfSavedBoards')! + 1;
    await sharedPref.setData('numOfSavedBoards', ctn);
    await sharedPref.setData('id${ctn.toString()}', ctn);
    await sharedPref.setData(
        'numOfOpenedCells${ctn.toString()}', boards.numOfOpenedCells!);
    await sharedPref.setData(
        'cells${ctn.toString()}', json.encode(boards.cells));
    await sharedPref.setData(
        'mines${ctn.toString()}', json.encode(boards.mines));
    await sharedPref.setData(
        'openedCells${ctn.toString()}', json.encode(boards.openedCells));
    await sharedPref.setData(
        'date${ctn.toString()}', DateTime.now().toString());
    animationedAlertWithActions(AppAnimations.done, "Board is saved", () {
      Get.back();
    }, context, icon: Icons.arrow_back);
  }

   loadBoard(int boardId) async {
    Board board = Board(
        0,
        false,
        false,
        [],
        [],
        json.decode(await sharedPref.getString("cells${boardId.toString()}")!),
        json.decode(
            await sharedPref.getString("openedCells${boardId.toString()}")!),
        json.decode(await sharedPref.getString("mines${boardId.toString()}")!),
        await sharedPref.getInt("numOfOpenedCells${boardId.toString()}")!,
        await sharedPref.getInt("id${boardId.toString()}")!,
        []);
    return board;
  }
}
