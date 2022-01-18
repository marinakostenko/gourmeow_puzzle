import 'package:equatable/equatable.dart';

import 'ingredient.dart';

class Meal extends Equatable {
  final Meals meal;
  final List<Ingredients> ingredients;

  const Meal(this.meal, this.ingredients);

  @override
  List<Object?> get props => [meal, ingredients];
}


enum Meals {
  sandwich,
  burger,
  tunaSalad,
  steak,
  cesar,
}