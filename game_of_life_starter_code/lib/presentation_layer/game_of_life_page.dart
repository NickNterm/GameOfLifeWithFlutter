import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game_of_life_starter_code/core/cell_renderer/cell_renderer.dart';
import 'package:game_of_life_starter_code/core/constants/colors.dart';
import 'package:game_of_life_starter_code/core/observer/grid_observer.dart';

import '../core/builder/grid_builder.dart';
import '../core/singleton/fps_singleton.dart';
import '../core/singleton/grid_singleton.dart';
import '../core/state/grid_state.dart';
import '../domain_layer/entries/grid.dart';
import '../patterns/grid_starts.dart';

class GameOfLifePage extends StatefulWidget {
  const GameOfLifePage({Key? key}) : super(key: key);

  @override
  State<GameOfLifePage> createState() => _GameOfLifePageState();
}

class _GameOfLifePageState extends State<GameOfLifePage> {
  late GridObserver _gridObserver;
  CellRenderer _cellRenderer = NoBorderCellRenderer();
  String fps = "-0";
  Timer? timer;
  Duration duration = const Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game of Life'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/info');
            },
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
                        return _cellRenderer.render(
                          grid.cells[index],
                        );
                      }),
                    );
                  } else {
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
                          Visibility(
                            visible: timer != null,
                            child: Text(
                              'FPS: $fps',
                            ),
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
            right: 20,
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Controls",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  _gridObserver.eventSink
                                      .add(GridEvent.tickGrid);
                                },
                                icon: const Icon(Icons.redo),
                              ),
                              IconButton(
                                onPressed: timer == null
                                    ? () {
                                        timer =
                                            Timer.periodic(duration, (Timer t) {
                                          fps = FPSSingleton().fps.toString();
                                          setState(() {});
                                          _gridObserver.eventSink
                                              .add(GridEvent.tickGrid);
                                        });
                                        setState(() {});
                                      }
                                    : null,
                                icon: const Icon(Icons.timer),
                              ),
                              IconButton(
                                onPressed: timer != null
                                    ? () {
                                        timer!.cancel();
                                        timer = null;
                                        setState(() {});
                                      }
                                    : null,
                                icon: const Icon(Icons.timer_off),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade900,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            "Grid",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    _cellRenderer = NoBorderCellRenderer();
                                    setState(() {});
                                  },
                                  child: const Icon(Icons.border_clear),
                                ),
                                const SizedBox(
                                  width: 17,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _cellRenderer = NormalBorderCellRenderer();
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 3,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 17,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _cellRenderer = PrimaryColorCellRenderer();
                                    setState(() {});
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(5),
                                    width: 23,
                                    height: 23,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: kPrimaryColor,
                                        width: 3,
                                      ),
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GridSingleton().director.setBuilder(
                              PatternGridBuilder(pattern: glider),
                            );

                        GridSingleton().director.buildGrid();
                        _gridObserver.eventSink.add(GridEvent.setGrid);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Glider",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GridSingleton().director.setBuilder(
                              PatternGridBuilder(pattern: glider_gun),
                            );

                        GridSingleton().director.buildGrid();
                        _gridObserver.eventSink.add(GridEvent.setGrid);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Glider Gun",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GridSingleton().director.setBuilder(
                              PatternGridBuilder(pattern: diamond_4_8_12),
                            );

                        GridSingleton().director.buildGrid();
                        _gridObserver.eventSink.add(GridEvent.setGrid);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Diamond",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        GridSingleton().director.setBuilder(
                              PatternGridBuilder(pattern: spaceship30p5h2v0),
                            );

                        GridSingleton().director.buildGrid();
                        _gridObserver.eventSink.add(GridEvent.setGrid);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Ship 1",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GridSingleton().director.setBuilder(
                              PatternGridBuilder(pattern: ship2),
                            );

                        GridSingleton().director.buildGrid();
                        _gridObserver.eventSink.add(GridEvent.setGrid);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Ship 2",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        GridSingleton().director.setBuilder(
                              RandomGridBuilder(),
                            );

                        GridSingleton().director.buildGrid();
                        _gridObserver.eventSink.add(GridEvent.setGrid);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blueGrey.shade900,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Random",
                          style: TextStyle(
                            fontSize: 20,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _gridObserver.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _gridObserver = GridObserver();
    _gridObserver.eventSink.add(GridEvent.setGrid);
  }
}
