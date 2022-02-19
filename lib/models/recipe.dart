import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'meal.dart';

class Recipe extends Equatable {
  Meals meal;
  AssetImage mealImage;
  List<AssetImage> ingredientsImages;

  Recipe({
    required this.meal,
    required this.mealImage,
    required this.ingredientsImages,
  });

  @override
  List<Object?> get props => [meal, mealImage, ingredientsImages];
}
