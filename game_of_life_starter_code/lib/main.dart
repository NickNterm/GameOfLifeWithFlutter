import 'dart:math';

import 'package:flutter/material.dart';
import 'package:game_of_life_starter_code/presentation_layer/game_of_life_page.dart';

const int _alive = 1;
const int _dead = 0;

void main() {
  //add this
  runApp(
    const MaterialApp(home: GameOfLifePage()),
  );
}

class GameOfLife extends StatefulWidget {
  const GameOfLife({Key? key}) : super(key: key);

  @override
  _GameOfLifeState createState() => _GameOfLifeState();
}

class _GameOfLifeState extends State<GameOfLife> {
  late List<List<int>> _grid;
  late int _rows;
  late int _columns;
  late int _generation;
  late Random genLife = Random();

  @override
  void initState() {
    super.initState();
    _rows = 100;
    _columns = 100;
    _generation = 0;
    _initGrid();
  }

  void _initGrid() {
    _grid = List.generate(_rows, (_) => List.filled(_columns, _dead));
    for (int i = 0; i < _rows; i++) {
      for (int j = 0; j < _columns; j++) {
        _grid[i][j] = genLife.nextBool() ? 1 : 0;
      }
    }
  }

  int _countAliveNeighbors(int row, int column) {
    int count = 0;
    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (i == 0 && j == 0) continue;
        int r = row + i;
        int c = column + j;
        if (r >= 0 &&
            r < _rows &&
            c >= 0 &&
            c < _columns &&
            _grid[r][c] == _alive) {
          count++;
        }
      }
    }
    return count;
  }

  void _tick() {
    setState(() {
      _generation++;
      List<List<int>> nextGrid =
          List.generate(_rows, (_) => List.filled(_columns, 0));
      for (int i = 0; i < _rows; i++) {
        for (int j = 0; j < _columns; j++) {
          int neighbors = _countAliveNeighbors(i, j);
          if (_grid[i][j] == _alive) {
            if (neighbors == 2 || neighbors == 3) {
              nextGrid[i][j] = _alive;
            } else {
              nextGrid[i][j] = _dead;
            }
          } else {
            if (neighbors == 3) {
              nextGrid[i][j] = _alive;
            } else {
              nextGrid[i][j] = _dead;
            }
          }
        }
      }
      _grid = nextGrid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generation: $_generation'),
      ),
      body: GridView.count(
        crossAxisCount: _columns,
        children: List.generate(_rows * _columns, (index) {
          int row = index ~/ _columns;
          int column = index % _columns;
          return Container(
            decoration: BoxDecoration(
              color: _grid[row][column] == _alive ? Colors.black : Colors.white,
              border: Border.all(
                color: Colors.grey,
                width: 0.1,
              ),
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _tick,
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
