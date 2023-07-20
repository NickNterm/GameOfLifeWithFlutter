import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/singleton/fps_singleton.dart';
import 'cell.dart';

// Grid Class
// Has fullSize and rowLen for the grid size.
// it also contins all the cells and manages the updates of the grid
class Grid {
  // for size
  int fullSize;
  int rowLen;

  // It is a one dimension list to have easier managment
  List<Cell> cells = [];

  // Constractor
  Grid({
    this.rowLen = 60,
    this.fullSize = 360,
    List<List<int>> pattern = const [],
  }) {
    // fill the cells with dead cells
    for (int i = 0; i < fullSize; i++) {
      cells.add(Cell(isAlive: false));
    }

    // if there is a pattern add it in the middle
    // Place the pattern in the middle if there is one
    // First flip the pattern in the x and y axis
    if (pattern.isNotEmpty) {
      int startRow = (rowLen - pattern[0].length) ~/ 2;
      int startCol = (fullSize ~/ rowLen - pattern.length) ~/ 2;

      // doing a double for loop to run the pattern
      for (int i = 0; i < pattern.length; i++) {
        for (int j = 0; j < pattern[0].length; j++) {
          int workingCellIndex = startRow + j + rowLen * (i + startCol);
          Cell workingCell = cells[workingCellIndex];
          workingCell.setIsAlive(pattern[i][j] == 1);
          if (workingCell.isAlive == true) {
            incrementNeighborCount(workingCellIndex, cells);
          }
        }
      }
      // if there is no pattern fill the grid with random cells
    } else {
      for (int i = 0; i < fullSize; i++) {
        cells[i].setIsAlive(Random().nextBool());
        if (cells[i].isAlive == true) {
          incrementNeighborCount(i, cells);
        }
      }
    }
    printGrid(cells);
    printGridNeighbor(cells);
  }

  // This function is used to incrementNeighbors in all the neighbor of a live cell
  void incrementNeighborCount(int i, List<Cell> list) {
    // get the index of all the neighbors
    // even if you are in the edge of the board just go to the other side
    int leftIndex = i % rowLen == 0 ? i + (rowLen - 1) : i - 1;
    int rightIndex = i % rowLen == rowLen - 1 ? i - (rowLen - 1) : i + 1;
    int topIndex = i - rowLen < 0 ? i + (fullSize - rowLen) : i - rowLen;
    int bottomIndex =
        i + rowLen >= fullSize ? i - (fullSize - rowLen) : i + rowLen;
    int topLeftIndex =
        topIndex % rowLen == 0 ? topIndex + (rowLen - 1) : topIndex - 1;
    int topRightIndex = topIndex % rowLen == rowLen - 1
        ? topIndex - (rowLen - 1)
        : topIndex + 1;
    int bottomLeftIndex = bottomIndex % rowLen == 0
        ? bottomIndex + (rowLen - 1)
        : bottomIndex - 1;
    int bottomRightIndex = bottomIndex % rowLen == rowLen - 1
        ? bottomIndex - (rowLen - 1)
        : bottomIndex + 1;

    // increment the neighbor count of all the neighbors
    list[leftIndex].incrementNeighbors();
    list[rightIndex].incrementNeighbors();
    list[topRightIndex].incrementNeighbors();
    list[bottomRightIndex].incrementNeighbors();
    list[topLeftIndex].incrementNeighbors();
    list[topIndex].incrementNeighbors();
    list[bottomIndex].incrementNeighbors();
    list[bottomLeftIndex].incrementNeighbors();
  }

  // This function is the pulse of the game
  void tickGrid() {
    // create a temp grid to store the next generation
    List<Cell> nextGrid = [];
    for (int i = 0; i < fullSize; i++) {
      // fill it with empty cells
      nextGrid.add(Cell(isAlive: false));
    }

    // for each cell check if it should live or die
    for (int i = 0; i < fullSize; i++) {
      if (cells[i].shouldLiveNextGen()) {
        nextGrid[i].setIsAlive(true);
        incrementNeighborCount(i, nextGrid);
      } else {
        nextGrid[i].setIsAlive(false);
      }
    }
    // then clear the old cells
    cells.clear();
    // and add the new cells
    cells.addAll(nextGrid);
    // update the fps counter
    FPSSingleton().update();
  }

  // prints the given grid in the console
  void printGrid(List<Cell> gridCells) {
    debugPrint("---------------");
    for (int i = 0; i < fullSize; i++) {
      debugPrint(gridCells[i].isAlive.toString());
    }
    debugPrint("---------------");
  }

  // prints the neighbors from the given grid in the console
  void printGridNeighbor(List<Cell> gridCells) {
    debugPrint("---------------");
    for (int i = 0; i < fullSize; i++) {
      debugPrint(gridCells[i].neighbors.toString());
    }
    debugPrint("---------------");
  }
}
