import '../../patterns/grid_starts.dart';
import '../builder/grid_builder.dart';
import '../builder/grid_director.dart';

class GridSingleton {
  // singleton instance
  static GridSingleton? instance;

  GridDirector director = GridDirector();

  // contructor that returns the instance
  factory GridSingleton() {
    return instance ?? GridSingleton._internal();
  }

  // internal constructor
  GridSingleton._internal() {
    director.setBuilder(PatternGridBuilder(pattern: glider_gun));
    director.buildGrid();
    instance = this;
  }

  // create an set a new grid
  void setGridDirector(GridDirector ndirector) {
    director = ndirector;
  }
}
