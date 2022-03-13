import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Ingredient extends Equatable {
  final Ingredients ingredient;

  const Ingredient({required this.ingredient});

  @override
  List<Object?> get props => [ingredient];
}

enum Ingredients {
  none,

  rice,
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
  AssetImage get ingredientImage {
    switch (this) {
      case Ingredients.none:
        return const AssetImage('assets/images/default.png');
      case Ingredients.rice:
        return const AssetImage('assets/images/ingredients/rice.png');
      case Ingredients.nori:
        return const AssetImage('assets/images/ingredients/nori.png');
      case Ingredients.egg:
        return const AssetImage('assets/images/ingredients/egg.png');
      case Ingredients.shrimps:
        return const AssetImage('assets/images/ingredients/shrimps.png');
      case Ingredients.salmon:
        return const AssetImage('assets/images/ingredients/salmon.png');
      case Ingredients.lettuce:
        return const AssetImage('assets/images/ingredients/salad.png');
      case Ingredients.mango:
        return const AssetImage('assets/images/ingredients/mango.png');
      case Ingredients.chicken:
        return const AssetImage('assets/images/ingredients/chicken.png');
      case Ingredients.noodles:
        return const AssetImage('assets/images/ingredients/noodles.png');
      case Ingredients.chilli:
        return const AssetImage('assets/images/ingredients/chilli.png');
      case Ingredients.shiitake:
        return const AssetImage('assets/images/ingredients/shiitake.png');
      case Ingredients.patty:
        return const AssetImage('assets/images/ingredients/patty.png');
      case Ingredients.bun:
        return const AssetImage('assets/images/ingredients/bun.png');
      case Ingredients.lobster:
        return const AssetImage('assets/images/ingredients/lobster.png');
      case Ingredients.butter:
        return const AssetImage('assets/images/ingredients/butter.png');
      case Ingredients.lemon:
        return const AssetImage('assets/images/ingredients/lemon.png');
      case Ingredients.flour:
        return const AssetImage('assets/images/ingredients/flour.png');
      case Ingredients.milk:
        return const AssetImage('assets/images/ingredients/milk.png');
      case Ingredients.meat:
        return const AssetImage('assets/images/ingredients/meat.png');
      case Ingredients.garlic:
        return const AssetImage('assets/images/ingredients/garlic.png');
      case Ingredients.wine:
        return const AssetImage('assets/images/ingredients/wine.png');
      case Ingredients.apple:
        return const AssetImage('assets/images/ingredients/apple.png');
      case Ingredients.zucchini:
        return const AssetImage('assets/images/ingredients/zucchini.png');
      case Ingredients.mussels:
        return const AssetImage('assets/images/ingredients/mussels.png');
      case Ingredients.eggplant:
        return const AssetImage('assets/images/ingredients/eggplant.png');
      case Ingredients.tomato:
        return const AssetImage('assets/images/ingredients/tomato.png');
      default:
        return const AssetImage('assets/images/default.png');
    }
  }

  static Ingredients generateRandomIngredient(List<Ingredient> ingredients) {
    while(true) {
      var rnd = Random();
      var ingredient = Ingredients.values[rnd.nextInt(Ingredients.values.length - 1) + 1];

      int count = 0;
      for (var element in ingredients) {
        if(element.ingredient == ingredient) {
          count++;
        }
      }

      if(count < 2) {
        return ingredient;
      }
    }

  }
}
