import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/meal.dart';

class CatsBuilder extends StatelessWidget {
  final List<Cat> cats;

  const CatsBuilder({Key? key, required this.cats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(cats.length, (index) {
          Cat cat = cats.elementAt(index);
          AssetImage image = cat.image;

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  // color: cat.color,
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: image,
                    alignment: Alignment.center,
                    repeat: ImageRepeat.noRepeat,
                  ),
                ),
              ),
              _mealAndLives(cat),
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
          height: 100,
          width: 100,
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
                size: 20,
              );
            } else {
              return Icon(
                CupertinoIcons.heart,
                color: Colors.red,
                size: 20,
              );
            }
          }),
        ),
      ],
    );
  }
}
