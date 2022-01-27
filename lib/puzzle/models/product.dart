import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/utils/copyable.dart';

import 'cat.dart';

class Product extends Copyable<Product> {
  Ingredient ingredient;
  Meal meal;
  BoardPosition position;
  bool isSelected;
  Drag draggable;

  Cat cat;

  Product({
    required this.ingredient,
    required this.meal,
    required this.position,
    required this.isSelected,
    required this.cat,
    required this.draggable,
  });

  @override
  Product copyWith(
          {Ingredient? ingredient,
          Meal? meal,
          BoardPosition? position,
          bool? isSelected,
            Drag? draggable,
          Cat? cat}) =>
      Product(
        ingredient: this.ingredient,
        meal: this.meal,
        position: this.position,
        isSelected: this.isSelected,
        draggable: this.draggable,
        cat: this.cat,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          ingredient == other.ingredient &&
          meal == other.meal &&
          position == other.position &&
          isSelected == other.isSelected &&
          draggable == other.draggable &&
          cat == other.cat;

  @override
  int get hashCode =>
      ingredient.hashCode ^
      meal.hashCode ^
      position.hashCode ^
      isSelected.hashCode ^
      draggable.hashCode ^
      cat.hashCode;
}

enum Drag {
  drag,
  drop,
}
