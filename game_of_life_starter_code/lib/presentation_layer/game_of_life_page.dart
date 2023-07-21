import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_of_life_starter_code/core/constants/colors.dart';
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
    Timer.periodic(const Duration(milliseconds: 200), (Timer t) {
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
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.games),
          ),
        ],
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
                                ? kPrimaryColor
                                : kBackgroundColor,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.4),
                              width: 0.5,
                              strokeAlign: 0.25,
                            ),
                          ),
                        );
                      }),
                    );
                  } else {
                    print("No data");
                    return const Text(
                      'Empty data',
                    );
                  }
                }),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade900,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.all(10),
              child: StreamBuilder<GridState>(
                  stream: _gridObserver.gridStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Generation: ${snapshot.data!.getGrid().numOfGeneration}",
                          ),
                          Text(
                            'FPS: $fps',
                          ),
                        ],
                      );
                    } else {
                      return const Text("Generation: 0");
                    }
                  }),
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
