import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Ingredient extends Equatable {
  final Ingredients ingredient;

  const Ingredient({required this.ingredient});

  @override
  List<Object?> get props => [ingredient];
}

// enum Ingredients {
//   none,
//   tuna,
//   tomato,
//   meat,
//   salad,
//   bread,
//   avocado,
//   bun,
//   croutons,
//   cheese,
//   onion,
//   rise,
//   nori,
//   egg,
//   shrimps
// }

enum Ingredients {
  none,

  rise,
  nori,
  egg,
  shrimps,
  salmon,
  lettuce,
  mango,
  chicken,
  noodles,
  chilli,
  shiitake,

  patty,
  bun,
  lobster,
  butter,
  lemon,
  flour,
  milk,
  meat,
  garlic,
  wine,
  apple,

  zucchini,
  mussels,
  eggplant,
  tomato,

}


extension IngredientsExt on Ingredients {
  static Ingredients generateRandomIngredient() {
    var rnd = Random();
    var ingredient =
    Ingredients.values[rnd.nextInt(Ingredients.values.length - 1) + 1];
    debugPrint("Ingredient ${ingredient.name}");
    return ingredient;
  }
}