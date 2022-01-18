import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';

class Cat extends Equatable {
  final Color color;
  final Meal meal;
  final int livesCount;

  Cat({required this.color, required this.meal, required this.livesCount});

  @override
  List<Object?> get props => [color, meal, livesCount];
}