import '../../domain_layer/entries/grid.dart';
import '../singleton/grid_singleton.dart';

// GridState is an abstract class that has two methods:
abstract class GridState {
  Grid getGrid();
  void nextState();
}

// GridLoaded is a concrete class that implements GridState:
class GridLoaded implements GridState {
  final Grid grid;

  GridLoaded({required this.grid});

  @override
  Grid getGrid() {
    return grid;
  }

  @override
  void nextState() {
    GridSingleton().director.getBuilder().tickGrid();
  }
}

// GridLoading is a concrete class that implements GridState:
class GridLoading implements GridState {
  @override
  Grid getGrid() {
    return Grid();
  }

  @override
  void nextState() {}
}
