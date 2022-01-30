import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Ingredient extends Equatable {
  final Ingredients ingredient;

  const Ingredient({required this.ingredient});

  @override
  List<Object?> get props => [ingredient];
}

enum Ingredients { none, tuna, tomato, meat, salad, bread, avocado }

extension IngredientsExt on Ingredients {
  static Ingredients generateRandomIngredient() {
    var rnd = Random();
    var ingredient =
        Ingredients.values[rnd.nextInt(Ingredients.values.length - 1) + 1];
    debugPrint("Ingredient ${ingredient.name}");
    return ingredient;
  }
}
