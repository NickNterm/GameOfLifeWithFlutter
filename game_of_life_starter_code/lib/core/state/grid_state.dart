import '../../domain_layer/entries/grid.dart';

abstract class GridState {
  Grid getGrid();
  void nextState();
}

class GridLoaded implements GridState {
  final Grid grid;

  GridLoaded({required this.grid});

  @override
  Grid getGrid() {
    return grid;
  }

  @override
  void nextState() {
    grid.tickGrid();
  }
}

class GridLoading implements GridState {
  @override
  Grid getGrid() {
    return Grid();
  }

  @override
  void nextState() {}
}
