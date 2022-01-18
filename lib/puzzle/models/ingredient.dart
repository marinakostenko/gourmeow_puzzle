import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final Ingredients ingredient;
  final List<Ingredients> pairs;

  const Ingredient(this.ingredient, this.pairs);

  @override
  List<Object?> get props => [ingredient, pairs];
}


enum Ingredients {
  tuna,
  tomato,
  meat,
  salad,
  bread
}