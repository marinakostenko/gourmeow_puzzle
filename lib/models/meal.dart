import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final Meals meal;

  const Meal({required this.meal});

  @override
  List<Object?> get props => [meal];
}

enum Meals {
  none,

  eggRise,
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
  chickenInSider,
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
        return [Meals.eggRise, Meals.sushi, Meals.mangoSalad, Meals.pho, Meals.friedNoodles];
      case Cuisine.french:
        return [Meals.croissant, Meals.bakedSalmon, Meals.moules, Meals.ratatouille, Meals.chickenInSider];
      default:
        return [];
    }
  }
}
