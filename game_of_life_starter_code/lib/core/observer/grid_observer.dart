import 'dart:async';

import 'package:game_of_life_starter_code/core/state/grid_state.dart';

import '../singleton/grid_singleton.dart';

enum GridEvent { tickGrid, setGrid }

class GridObserver {
  // State Stream Controller
  final StreamController<GridState> _counterController =
      StreamController<GridState>.broadcast();
  StreamSink<GridState> get gridSink => _counterController.sink;
  Stream<GridState> get gridStream => _counterController.stream;

  GridState state = GridLoaded(grid: GridSingleton().director.getGrid());

  // Event Stream Controller
  final StreamController<GridEvent> _eventController =
      StreamController<GridEvent>();
  StreamSink<GridEvent> get eventSink => _eventController.sink;
  Stream<GridEvent> get eventStream => _eventController.stream;

  StreamSubscription? listener;

  GridObserver() {
    _counterController
        .add(GridLoaded(grid: GridSingleton().director.getGrid()));
    listener = eventStream.listen((GridEvent event) {
      switch (event) {
        case GridEvent.tickGrid:
          if (state is GridLoaded) {
            // Grid tempGrid = (state as GridLoaded).grid;
            gridSink.add(GridLoading());
            state.nextState();
            gridSink.add(GridLoaded(grid: state.getGrid()));
          }
          break;
        case GridEvent.setGrid:
          state = GridLoaded(grid: GridSingleton().director.getGrid());
          _counterController.add(state);
          break;
        default:
          break;
      }
    });
  }

  void dispose() {
    _counterController.close();
    _eventController.close();
    listener?.cancel();
  }
}
