import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';

class Cat extends Equatable {
  final Color color;
  final Meal meal;
  final int livesCount;
  final Cuisine cuisine;

  Cat({required this.color, required this.meal, required this.livesCount, required this.cuisine});

  @override
  List<Object?> get props => [color, meal, livesCount, cuisine];
}