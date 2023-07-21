import 'package:game_of_life_starter_code/domain_layer/entries/grid.dart';
import 'package:game_of_life_starter_code/patterns/grid_starts.dart';

class GridSingleton {
  static GridSingleton? instance;

  Grid grid = Grid(
    rowLen: 50,
    fullSize: 4000,
    pattern: glider_gun,
  );

  factory GridSingleton() {
    return instance ?? GridSingleton._internal();
  }

  GridSingleton._internal() {
    instance = this;
  }

  void setGrid(Grid newGrid) {
    grid = newGrid;
  }

  void loadPattern(List<List<int>> pattern) {
    Grid tempGrid = grid;
    grid = Grid(
      rowLen: tempGrid.rowLen,
      fullSize: tempGrid.fullSize,
      pattern: pattern,
    );
  }
}
