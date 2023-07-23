import 'package:flutter/material.dart';

import 'cell.dart';

// Grid Class
// Has fullSize and rowLen for the grid size.
// it also contins all the cells and manages the updates of the grid
class Grid {
  // for size
  int fullSize;
  int rowLen;

  // for the Generation counter
  int numOfGeneration = 0;

  // It is a one dimension list to have easier managment
  List<Cell> cells = [];

  // Constractor
  Grid({
    this.rowLen = 60,
    this.fullSize = 360,
    List<List<int>> pattern = const [],
  });

  void setCellList(List<Cell> newCells) {
    cells.clear();
    cells.addAll(newCells);
  }

  // prints the given grid in the console
  void printGrid(List<Cell> gridCells) {
    debugPrint("---------------");

    String row = '';
    for (int i = 0; i < fullSize; i++) {
      row += gridCells[i].isAlive ? "1" : "0";
      if ((i + 1) % rowLen == 0) {
        debugPrint(row);
        row = '';
      }
    }
    debugPrint("---------------");
  }

  // prints the neighbors from the given grid in the console
  void printGridNeighbor(List<Cell> gridCells) {
    debugPrint("---------------");

    String row = '';
    for (int i = 0; i < fullSize; i++) {
      row += gridCells[i].neighbors.toString();
      if ((i + 1) % rowLen == 0) {
        debugPrint(row);
        row = '';
      }
    }
    debugPrint("---------------");
  }
}
