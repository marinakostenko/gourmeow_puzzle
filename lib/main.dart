import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/config/main_theme.dart';
import 'package:gourmeow_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:gourmeow_puzzle/puzzle/view/puzzle_page.dart';
import 'package:gourmeow_puzzle/slide_puzzle/slide_puzzle_page.dart';
import 'package:gourmeow_puzzle/timer/ticker.dart';
import 'package:gourmeow_puzzle/timer/timer_count_up/bloc/timer_count_up_bloc.dart';
import 'package:gourmeow_puzzle/widgets/logo.dart';

import 'audio_player/bloc/audio_control_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PuzzleBloc(),
        ),
        BlocProvider(
          create: (context) => AudioControlBloc(),
        ),
        BlocProvider(
          create: (context) => TimerCountUpBloc(ticker: const Ticker()),
        ),
      ],
      child: MaterialApp(
        title: 'Gourmeow Puzzle',
        theme: MainThemeData.themeData(),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const LogoImage(),
        elevation: 0,
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            width: 200,
            height: 200,
            margin: EdgeInsets.all(30),
            child: TextButton(
              onPressed: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (context) => const SlidePuzzlePage(),
                  ),
                );
              },
              child: const Text(
                "Slide endless_puzzle mode",
                style: TextStyle(fontSize: 32, color: Colors.white),
              ),
            ),
          ),
          // Container(
          //   width: 200,
          //   height: 200,
          //   margin: EdgeInsets.all(30),
          //   child: TextButton(
          //     onPressed: () {
          //       Navigator.of(context).push<void>(
          //         MaterialPageRoute(
          //           builder: (context) => const PuzzlePage(),
          //         ),
          //       );
          //     },
          //     child: const Text(
          //       "Endless mode",
          //       style: TextStyle(fontSize: 32),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
