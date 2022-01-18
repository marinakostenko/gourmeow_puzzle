import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';

import 'cat.dart';

class Product extends Equatable {
  Ingredient ingredient;
  Meal meal;
  BoardPosition position;
  bool isSelected;
  Cat cat;

  Product({
    required this.ingredient,
    required this.meal,
    required this.position,
    required this.isSelected,
    required this.cat});

  @override
  List<Object?> get props => [ingredient, meal, position, isSelected, cat];
}


