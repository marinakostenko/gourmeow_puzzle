import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/puzzle/view/bloc/puzzle_bloc.dart';
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
          home: PuzzlePage(),
        ),);
  }
}
