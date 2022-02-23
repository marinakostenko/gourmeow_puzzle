import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'cat.dart';
import 'meal.dart';

class Recipe extends Equatable {
  Meals meal;
  AssetImage mealImage;
  List<AssetImage> ingredientsImages;
  Cuisine cuisine;
  Color dishColor;

  Recipe({
    required this.meal,
    required this.mealImage,
    required this.ingredientsImages,
    required this.cuisine,
    required this.dishColor,
  });

  @override
  List<Object?> get props => [meal, mealImage, ingredientsImages, cuisine, dishColor];
}
