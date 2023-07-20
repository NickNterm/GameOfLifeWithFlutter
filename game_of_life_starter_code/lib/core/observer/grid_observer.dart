import 'dart:async';

import 'package:game_of_life_starter_code/core/state/grid_state.dart';

import '../singleton/grid_singleton.dart';

enum GridEvent { tickGrid }

class GridObserver {
  // State Stream Controller
  final StreamController<GridState> _counterController =
      StreamController<GridState>();
  StreamSink<GridState> get gridSink => _counterController.sink;
  Stream<GridState> get gridStream => _counterController.stream;

  GridState state = GridLoaded(grid: GridSingleton().grid);

  // Event Stream Controller
  final StreamController<GridEvent> _eventController =
      StreamController<GridEvent>();
  StreamSink<GridEvent> get eventSink => _eventController.sink;
  Stream<GridEvent> get eventStream => _eventController.stream;

  StreamSubscription? listener;

  GridObserver() {
    _counterController.add(GridLoaded(grid: GridSingleton().grid));
    listener = eventStream.listen((GridEvent event) {
      switch (event) {
        case GridEvent.tickGrid:
          if (state is GridLoaded) {
            // Grid tempGrid = (state as GridLoaded).grid;
            gridSink.add(GridLoading());
            state.nextState();
            gridSink.add(GridLoaded(grid: state.getGrid()));
          } else {
            print("To Many Ticks");
          }
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
