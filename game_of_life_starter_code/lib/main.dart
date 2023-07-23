import 'package:flutter/material.dart';
import 'package:game_of_life_starter_code/presentation_layer/game_of_life_page.dart';
import 'package:game_of_life_starter_code/presentation_layer/info_page.dart';
import 'package:game_of_life_starter_code/presentation_layer/splash_page.dart';

import 'core/constants/colors.dart';

void main() {
  runApp(
    const MaterialApp(home: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Of Life',
      darkTheme: ThemeData(
        appBarTheme: AppBarTheme.of(context).copyWith(
          centerTitle: true,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.grey.withOpacity(0.4),
          elevation: 0,
          backgroundColor: Colors.blueGrey.shade900,
        ),
        brightness: Brightness.dark,
        scaffoldBackgroundColor: kBackgroundColor,
        primarySwatch: kPrimaryColor,
        primaryColor: kPrimaryColor,
      ),
      routes: {
        '/game_of_life': (context) => const GameOfLifePage(),
        '/info': (context) => const InfoPage(),
      },
      home: const SplashPage(),
    );
  }
}
