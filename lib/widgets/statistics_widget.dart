import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';
import 'package:gourmeow_puzzle/timer/timer_count_up/timer_count_up.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key, required this.moves, required this.dishes, required this.displayMenu})
      : super(key: key);
  final int moves;
  final int dishes;
  final bool displayMenu;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    double fontSize = ratio < 1 ? size.height * 0.03 : size.width * 0.015;
    double sectionWidth = ratio < 1 ? size.width : size.width * 0.25;

    return Material(
      child: Container(
        alignment: Alignment.center,
        width: sectionWidth,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimerCountUp(
              iconSize: fontSize,
            ),
            SizedBox(
              height: fontSize * 0.8,
            ),
            Container(
              child: Text(
                "Number of moves $moves",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fontSize,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            SizedBox(
              height: fontSize * 0.8,
            ),
            Container(
              child: Text(
                "Prepared dishes $dishes / 8",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: fontSize,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
           _recipes(),
          ],
        ),
      ),
    );
  }

  Widget _recipes() {
    if (displayMenu) {
      return const Recipes(
        cuisine: Cuisine.none,
        text: Text("Menu"),
      );
    }

    return Container();
  }
}
