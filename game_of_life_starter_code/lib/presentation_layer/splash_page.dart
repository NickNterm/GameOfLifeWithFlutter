import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  int imageOpacity = 0;
  int titleOpacity = 0;
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 10), () {
      setState(() {
        imageOpacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 750), () {
      setState(() {
        titleOpacity = 1;
      });
    });
    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.pushReplacementNamed(context, '/game_of_life');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedOpacity(
              opacity: imageOpacity.toDouble(),
              duration: const Duration(milliseconds: 1000),
              child: Image.asset(
                'assets/GameOfLife.png',
                height: 100,
                width: 100,
              ),
            ),
            AnimatedOpacity(
              opacity: titleOpacity.toDouble(),
              duration: const Duration(milliseconds: 1000),
              child: const Text(
                'Game of Life',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
