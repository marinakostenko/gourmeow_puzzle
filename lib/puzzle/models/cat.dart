import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';

class Cat {
  Color color;
  Meal meal;
  int livesCount;
  Cuisine cuisine;

  Cat({required this.color, required this.meal, required this.livesCount, required this.cuisine});


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cat &&
          runtimeType == other.runtimeType &&
          color == other.color &&
          meal == other.meal &&
          livesCount == other.livesCount &&
          cuisine == other.cuisine;

  @override
  int get hashCode =>
      color.hashCode ^ meal.hashCode ^ livesCount.hashCode ^ cuisine.hashCode;
}