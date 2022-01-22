import 'package:equatable/equatable.dart';

import 'ingredient.dart';

class Meal extends Equatable {
  final Meals meal;
  final List<Ingredients> ingredients;

  const Meal({required this.meal, required this.ingredients});

  @override
  List<Object?> get props => [meal, ingredients];
}


enum Meals {
  none,
  sandwich,
  burger,
  tunaSalad,
  steak,
  cesar,
}