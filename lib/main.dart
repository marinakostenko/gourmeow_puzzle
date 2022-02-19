import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:gourmeow_puzzle/puzzle/view/puzzle_page.dart';

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
      ],
      child: MaterialApp(
        title: 'Gourmeow Puzzle',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
    return Column(
      children: [
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.all(30),
          child: TextButton(
            onPressed: () {},
            child: const Text(
              "Slide endless_puzzle mode",
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
        Container(
          width: 200,
          height: 200,
          margin: EdgeInsets.all(30),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (context) => const PuzzlePage(),
                ),
              );
            },
            child: const Text(
              "Endless mode",
              style: TextStyle(fontSize: 32),
            ),
          ),
        ),
      ],
    );
  }
}
