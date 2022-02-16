import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Meal extends Equatable {
  final Meals meal;


  const Meal({required this.meal});

  @override
  List<Object?> get props => [meal];
}

enum Meals {
  none,

  eggRice,
  sushi,
  mangoSalad,
  pho,
  friedNoodles,

  burger,
  lobsterTail,
  pancakes,
  steak,
  applePie,

  croissant,
  bakedSalmon,
  moules,
  ratatouille,
  chickenInCider,
}

extension MealsExt on Meals {
  AssetImage get mealImage {
    switch (this) {
      case Meals.none:
        return const AssetImage('assets/images/default.png');
      case Meals.eggRice:
        return const AssetImage('assets/images/meals/egg_rice.png');
      case Meals.sushi:
        return const AssetImage('assets/images/meals/sushi.png');
      case Meals.mangoSalad:
        return const AssetImage('assets/images/meals/mango_salad.png');
      case Meals.pho:
        return const AssetImage('assets/images/meals/pho.png');
      case Meals.friedNoodles:
        return const AssetImage('assets/images/meals/fried_noodles.png');
      case Meals.burger:
        return const AssetImage('assets/images/meals/burger.png');
      case Meals.lobsterTail:
        return const AssetImage('assets/images/meals/lobster_tail.png');
      case Meals.pancakes:
        return const AssetImage('assets/images/meals/pancakes.png');
      case Meals.steak:
        return const AssetImage('assets/images/meals/steak.png');
      case Meals.applePie:
        return const AssetImage('assets/images/meals/apple_pie.png');
      case Meals.croissant:
        return const AssetImage('assets/images/meals/croissant.png');
      case Meals.bakedSalmon:
        return const AssetImage('assets/images/meals/salmon_in_paper.png');
      case Meals.moules:
        return const AssetImage('assets/images/meals/mussels.png');
      case Meals.ratatouille:
        return const AssetImage('assets/images/meals/ratatouille.png');
      case Meals.chickenInCider:
        return const AssetImage('assets/images/meals/chicken_in_cider.png');
      default:
        return const AssetImage('assets/images/default.png');
    }
  }
}


enum Cuisine {
  none,
  french,
  american,
  asian
}

extension CuisineExt on Cuisine {
  static List<Meals> getMealsByCuisine(Cuisine cuisine) {
    switch (cuisine) {
      case Cuisine.american:
        return [Meals.burger, Meals.lobsterTail, Meals.pancakes, Meals.steak, Meals.applePie];
      case Cuisine.asian:
        return [Meals.eggRice, Meals.sushi, Meals.mangoSalad, Meals.pho, Meals.friedNoodles];
      case Cuisine.french:
        return [Meals.croissant, Meals.bakedSalmon, Meals.moules, Meals.ratatouille, Meals.chickenInCider];
      default:
        return [];
    }
  }
}
