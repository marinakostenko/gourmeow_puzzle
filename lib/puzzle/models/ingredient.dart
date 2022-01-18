import 'package:equatable/equatable.dart';

class Ingredient extends Equatable {
  final Ingredients ingredient;

  Ingredient({required this.ingredient});

  @override
  List<Object?> get props => [ingredient];
}


enum Ingredients {
  tuna,
  tomato,
  meat,
  salad,
  bread
}