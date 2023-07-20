import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_of_life_starter_code/core/observer/grid_observer.dart';

import '../core/singleton/fps_singleton.dart';
import '../core/state/grid_state.dart';
import '../domain_layer/entries/grid.dart';

class GameOfLifePage extends StatefulWidget {
  const GameOfLifePage({Key? key}) : super(key: key);

  @override
  State<GameOfLifePage> createState() => _GameOfLifePageState();
}

class _GameOfLifePageState extends State<GameOfLifePage> {
  late GridObserver _gridObserver;
  String fps = "-0";

  @override
  void initState() {
    super.initState();
    _gridObserver = GridObserver();
    Timer.periodic(const Duration(milliseconds: 50), (Timer t) {
      fps = FPSSingleton().fps.toString();
      setState(() {});
      _gridObserver.eventSink.add(GridEvent.tickGrid);
    });
  }

  @override
  void dispose() {
    _gridObserver.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game of Life'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: StreamBuilder<GridState>(
                stream: _gridObserver.gridStream,
                builder: (
                  BuildContext context,
                  AsyncSnapshot<GridState> snapshot,
                ) {
                  if (snapshot.hasData) {
                    Grid grid = snapshot.data!.getGrid();
                    return GridView.count(
                      crossAxisCount: grid.rowLen,
                      children: List.generate(grid.fullSize, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: grid.cells[index].isAlive == true
                                ? Colors.black
                                : Colors.white,
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.3,
                              strokeAlign: 0.15,
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    print("No data");
                    return Text(
                      'Empty data',
                    );
                  }
                }),
          ),
          Text(
            'FPS: ${fps}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                _gridObserver.eventSink.add(GridEvent.tickGrid);
              },
              child: const Text('Tick'),
            ),
          )
        ],
      ),
    );
  }
}
