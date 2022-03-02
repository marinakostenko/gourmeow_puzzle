import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';

class CatsBuilder extends StatefulWidget {
  final List<Cat> cats;

  const CatsBuilder({Key? key, required this.cats}) : super(key: key);

  @override
  _CatsBuilderState createState() => _CatsBuilderState();
}

class _CatsBuilderState extends State<CatsBuilder> {
  dynamic size;
  dynamic ratio;
  dynamic catsWidth;
  dynamic catsHeight;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    ratio = size.width / size.height;

    catsWidth = ratio < 1 ? size.width * 0.9 : size.width * 0.5;
    catsHeight = ratio < 1 ? size.height * 0.5 : size.height * 0.5;

    return SizedBox(
      height: catsHeight,
      width: catsWidth,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(widget.cats.length, (index) {
          Cat cat = widget.cats.elementAt(index);
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
              _mealAndLives(cat),
              _table(cat),
              _recipes(cat),
            ],
          );
        }),
      ),
    );
  }

  Widget _mealAndLives(Cat cat) {
    if (cat.meal.meal == Meals.none && cat.meals.isNotEmpty) {
      return Container();
    }

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10),
          alignment: Alignment.center,
          height: catsWidth * 0.2,
          width: catsWidth * 0.2,
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

  Widget _table(Cat cat) {
    if (cat.meal.meal == Meals.none && cat.meals.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.all(10),
        alignment: Alignment.center,
        height: catsHeight * 0.22,
        width: catsWidth / 3.5,
        decoration: BoxDecoration(
          color: Colors.brown,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(cat.servedMeals.length, (index) {
            Meal meal = cat.servedMeals.elementAt(index);
            AssetImage image = meal.meal.mealImage;

            return Container(
              alignment: Alignment.center,
              height: catsWidth * 0.08,
              width: catsWidth * 0.08,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                image: DecorationImage(
                  image: image,
                  alignment: Alignment.center,
                  repeat: ImageRepeat.noRepeat,
                ),
              ),
            );
          }),
        ),
      );
    }

    return Container();
  }
}
