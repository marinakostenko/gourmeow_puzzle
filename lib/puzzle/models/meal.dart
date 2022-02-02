import 'package:equatable/equatable.dart';

import 'ingredient.dart';

class Meal extends Equatable {
  final Meals meal;

  const Meal({required this.meal});


  @override
  List<Object?> get props => [meal];
}


enum Meals {
  none,
  sandwich,
  burger,
  tunaSalad,
  vegetableSalad,
  steak,
  cesar,
}

