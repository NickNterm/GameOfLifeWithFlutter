import 'dart:math';

import '../../domain_layer/entries/cell.dart';
import '../../domain_layer/entries/grid.dart';
import '../singleton/fps_singleton.dart';

abstract class GridBuilder {
  late Grid grid;
  void buildGrid(int rolLen, int fullSize) {
    grid = Grid(
      rowLen: rolLen,
      fullSize: fullSize,
    );
  }

  Grid getGrid() {
    return grid;
  }

  // This function is used to incrementNeighbors in all the neighbor of a live cell
  void incrementNeighborCount(int i, List<Cell> list) {
    // get the index of all the neighbors
    // even if you are in the edge of the board just go to the other side
    int rowLen = grid.rowLen;
    int fullSize = grid.fullSize;
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
    // increment the generation counter
    grid.numOfGeneration++;
    // create a temp grid to store the next generation
    List<Cell> nextGrid = [];
    for (int i = 0; i < grid.fullSize; i++) {
      // fill it with empty cells
      nextGrid.add(Cell(isAlive: false));
    }

    // for each cell check if it should live or die
    for (int i = 0; i < grid.fullSize; i++) {
      if (grid.cells[i].shouldLiveNextGen()) {
        nextGrid[i].setIsAlive(true);
        incrementNeighborCount(i, nextGrid);
      } else {
        nextGrid[i].setIsAlive(false);
      }
    }
    // then clear the old cells
    grid.cells.clear();
    // and add the new cells
    grid.cells.addAll(nextGrid);
    // update the fps counter
    FPSSingleton().update();
  }

  void setCells();
}

class PatternGridBuilder extends GridBuilder {
  final List<List<int>> pattern;
  PatternGridBuilder({required this.pattern});

  @override
  setCells() {
    List<Cell> cells = [];
    // fill the cells with dead cells
    for (int i = 0; i < grid.fullSize; i++) {
      cells.add(Cell(isAlive: false));
    }

    // if there is a pattern add it in the middle
    // Place the pattern in the middle if there is one
    // First flip the pattern in the x and y axis
    if (pattern.isNotEmpty) {
      int startRow = (grid.rowLen - pattern[0].length) ~/ 2;
      int startCol = (grid.fullSize ~/ grid.rowLen - pattern.length) ~/ 2;

      // doing a double for loop to run the pattern
      for (int i = 0; i < pattern.length; i++) {
        for (int j = 0; j < pattern[0].length; j++) {
          int workingCellIndex = startRow + j + grid.rowLen * (i + startCol);
          Cell workingCell = cells[workingCellIndex];
          workingCell.setIsAlive(pattern[i][j] == 1);
          if (workingCell.isAlive == true) {
            incrementNeighborCount(workingCellIndex, cells);
          }
        }
      }
      // if there is no pattern fill the grid with random cells
    } else {
      for (int i = 0; i < grid.fullSize; i++) {
        cells[i].setIsAlive(Random().nextBool());
        if (cells[i].isAlive == true) {
          incrementNeighborCount(i, cells);
        }
      }
    }
    grid.setCellList(cells);
  }
}

class EmptyGridBuilder extends GridBuilder {
  @override
  setCells() {
    List<Cell> cells = [];
    // fill the cells with dead cells
    for (int i = 0; i < grid.fullSize; i++) {
      cells.add(Cell(isAlive: false));
    }
    grid.setCellList(cells);
  }
}

class RandomGridBuilder extends GridBuilder {
  @override
  setCells() {
    List<Cell> cells = [];
    // fill the cells with dead cells
    for (int i = 0; i < grid.fullSize; i++) {
      cells.add(Cell(isAlive: Random().nextBool()));
    }
    for (int i = 0; i < grid.fullSize; i++) {
      if (cells[i].isAlive == true) {
        incrementNeighborCount(i, cells);
      }
    }
    grid.setCellList(cells);
  }
}
