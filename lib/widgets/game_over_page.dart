import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/cat.dart';

import 'cats_builder_widget.dart';

class GameOverPage extends StatelessWidget {
  final int moves;
  final int dishes;
  final List<Cat> cats;

  const GameOverPage(
      {Key? key, required this.moves, required this.dishes, required this.cats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.lightBlue.withOpacity(0.8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue.withOpacity(0.8),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(10.0),
              child: const Text(
                "Game over You made it!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 48, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ).copyWith(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  // context.read<SlidePuzzleBloc>().add(
                  //     const SlidePuzzleInitialized(shufflePuzzle: true, size: 6));
                },
                child: const Text(
                  "Restart",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, color: Colors.indigo),
                ),
              ),
            ),
            Hero(
              tag: 'cats-hero',
              child: CatsBuilder(
                cats: cats,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
