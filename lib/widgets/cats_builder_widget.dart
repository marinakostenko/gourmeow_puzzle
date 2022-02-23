import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';

class CatsBuilder extends StatelessWidget {
  final List<Cat> cats;

  const CatsBuilder({Key? key, required this.cats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;

    double catsWidth = ratio < 1 ? size.width * 0.9 : size.width * 0.5;
    double catsHeight = ratio < 1 ? size.height * 0.5 : size.height * 0.5;

    return SizedBox(
      height: catsHeight,
      width: catsWidth,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),

        children: List.generate(cats.length, (index) {
          Cat cat = cats.elementAt(index);
          AssetImage image = cat.image;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                height: catsHeight * 0.5,
                width: catsWidth / 3.5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: image,
                    alignment: Alignment.center,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
              ),
              _mealAndLives(cat, Size(catsWidth, catsHeight)),
              _recipes(cat),
            ],
          );
        }),
      ),
    );
  }

  Widget _mealAndLives(Cat cat, Size size) {
    if (cat.meal.meal == Meals.none && cat.meals.isNotEmpty) {
      return Container();
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          height: size.width * 0.2,
          width: size.width * 0.2,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: cat.meal.meal.mealImage,
              alignment: Alignment.center,
              repeat: ImageRepeat.noRepeat,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(3, (index) {
            if (index < cat.livesCount) {
              return Icon(
                CupertinoIcons.heart_fill,
                color: Colors.red,
                size: size.width * 0.05,
              );
            } else {
              return Icon(
                CupertinoIcons.heart,
                color: Colors.red,
                size: size.width * 0.05,
              );
            }
          }),
        ),
      ],
    );
  }

  Widget _recipes(Cat cat) {
    return Recipes(
      cuisine: cat.cuisine,
    );
  }
}
