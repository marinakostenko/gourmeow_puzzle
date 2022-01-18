import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';

import 'cat.dart';

class Product extends Equatable {
  final Ingredient ingredient;
  final Meal meal;
  final BoardPosition position;
  final bool isSelected;
  final Cat cat;

  const Product(this.ingredient, this.meal, this.position, this.isSelected, this.cat);

  @override
  List<Object?> get props => [ingredient, meal, position, isSelected, cat];

}