

import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Color Matching Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ColorMatchingGame(),
    );
  }
}

class ColorMatchingGame extends StatefulWidget {
  @override
  _ColorMatchingGameState createState() => _ColorMatchingGameState();
}

class _ColorMatchingGameState extends State<ColorMatchingGame> {
  List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
  ];

  List<Color> _gridColors = [];
  List<int> _selectedIndices = [];
  int _score = 0;
  Timer? _timer;
  int _timeRemaining = 60; // 60 seconds

  @override
  void initState() {
    super.initState();
    _initializeGrid();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _initializeGrid() {
    _gridColors.clear();
    _selectedIndices.clear();
    final random = Random();
    for (int i = 0; i < 25; i++) {
      _gridColors.add(_colors[random.nextInt(_colors.length)]);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _timer?.cancel();
        // End game logic
      }
    });
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _timeRemaining = 60;
      _initializeGrid();
      _startTimer();
    });
  }

  void _handleTileTap(int index) {
    setState(() {
      _selectedIndices.add(index);
      if (_selectedIndices.length == 2) {
        if (_gridColors[_selectedIndices[0]] == _gridColors[_selectedIndices[1]]) {
          // Colors match
          _gridColors[_selectedIndices[0]] = Colors.transparent;
          _gridColors[_selectedIndices[1]] = Colors.transparent;
          _score += 10; // Increase score
        }
        _selectedIndices.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Color Matching Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Time Remaining: $_timeRemaining seconds',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
              ),
              itemCount: 25,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _handleTileTap(index);
                  },
                  child: Container(
                    margin: EdgeInsets.all(4),
                    color: _gridColors[index],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              'Score: $_score',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _restartGame();
              },
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    );
  }
}
