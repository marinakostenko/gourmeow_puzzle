import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/config/main_theme.dart';
import 'package:gourmeow_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:gourmeow_puzzle/slide_puzzle/slide_puzzle_page.dart';
import 'package:gourmeow_puzzle/timer/ticker.dart';
import 'package:gourmeow_puzzle/timer/timer_count_up/bloc/timer_count_up_bloc.dart';
import 'package:gourmeow_puzzle/widgets/logo_widget.dart';

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
    var ratio = size.width / size.height;

    double fontSize = ratio < 1 ? size.width * 0.05 : size.height * 0.05;

    return Scaffold(
      appBar: AppBar(
        title: const LogoImage(),
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Container(
              //   padding: EdgeInsets.all(fontSize),
              //   width: ratio < 1 ? size.width * 0.8 : size.width * 0.3,
              //   child: Text(
              //       "Goal of puzzle is to fill tiles correspondent to guest color with proper meals",
              //     style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: fontSize * 0.5),
              //     textAlign: TextAlign.center,
              //   ),
              // ),
              SizedBox(
                width: ratio < 1 ? size.width : size.height * 0.7,
                height: ratio < 1 ? size.width : size.height * 0.7,
                child: Image.asset('assets/images/completed_board.png'),
              ),
              Container(
                padding: EdgeInsets.all(fontSize),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.all(fontSize * 0.5),
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all(
                        Theme.of(context).colorScheme.secondary),
                  ),
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (context) => const SlidePuzzlePage(),
                      ),
                    );
                  },
                  child: Text(
                    "Start game",
                    style: TextStyle(
                        fontSize: fontSize,
                        color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
