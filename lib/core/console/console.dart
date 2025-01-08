import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/features/home/data/board.dart';

class Consolee {
  late Board board;
  void run() {
      debugPrint(toString());
      debugPrint("\npress:\n (o) to open\n(f) flag");
      String? command = stdin.readLineSync()!;
      debugPrint("X = ");
      int? x = int.parse(stdin.readLineSync()!);
      debugPrint("Y = ");
      int? y = int.parse(stdin.readLineSync()!);
      switch (command) {
        case 'o':
          {
            board.openCells(board,x, y);
          }
        case 'f':
          {
            //flagCell(x, y);
          }

      }
    
  }
}
