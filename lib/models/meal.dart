import 'package:equatable/equatable.dart';

class Meal extends Equatable {
  final Meals meal;

  const Meal({required this.meal});

  @override
  List<Object?> get props => [meal];
}

enum Meals {
  none,
  sandwich,
  burger,
  tunaSalad,
  vegetableSalad,
  cesar,
  eggRise,
  tunaRoll,
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
        return [Meals.sandwich, Meals.burger, Meals.tunaSalad];
      case Cuisine.asian:
        return [Meals.eggRise, Meals.tunaRoll];
      case Cuisine.french:
        return [Meals.cesar, Meals.vegetableSalad];
      default:
        return [];
    }
  }
}
