import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/models/meal.dart';

class Cat {
  Color color;
  Meal meal;
  int livesCount;
  Cuisine cuisine;
  BoardPosition position;

  Cat(
      {required this.color,
      required this.meal,
      required this.livesCount,
      required this.cuisine,
      required this.position});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cat &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          meal == other.meal &&
          livesCount == other.livesCount &&
          cuisine == other.cuisine &&
          position == other.position;

  @override
  int get hashCode =>
      color.hashCode ^
      meal.hashCode ^
      livesCount.hashCode ^
      cuisine.hashCode ^
      position.hashCode;
}
