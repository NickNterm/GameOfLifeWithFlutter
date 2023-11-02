import '../../domain_layer/entries/grid.dart';
import 'grid_builder.dart';

class GridDirector {
  late GridBuilder _builder;

  void setBuilder(GridBuilder builder) {
    _builder = builder;
  }

  GridBuilder getBuilder() {
    return _builder;
  }

  Grid getGrid() {
    return _builder.getGrid();
  }

  void buildGrid() {
    _builder.buildGrid(40, 1600);
    _builder.setCells();
  }
}
