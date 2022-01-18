import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

class Utils {

  List<BoardPosition> getBoardPositionsList(int dimension) {
    final positions = <BoardPosition>[];

    for(int y = 1; y <= dimension; y++) {
      for(int x =  1; x <= dimension; x++) {
        positions.add(BoardPosition(x: x, y: y));
      }
    }

    return positions;
  }


  List<Product> defaultProductsList(int size) {
    Product tuna = Product(
        ingredient: Ingredient(ingredient: Ingredients.tuna),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(color: Colors.white, meal: Meal(meal: Meals.none, ingredients: []), livesCount: -1));

    Product bread = Product(
        ingredient: Ingredient(ingredient: Ingredients.bread),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(color: Colors.white, meal: Meal(meal: Meals.none, ingredients: []), livesCount: -1));

    Product meat = Product(
        ingredient: Ingredient(ingredient: Ingredients.meat),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(color: Colors.white, meal: Meal(meal: Meals.none, ingredients: []), livesCount: -1));

    Product salad = Product(
        ingredient: Ingredient(ingredient: Ingredients.salad),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(color: Colors.white, meal: Meal(meal: Meals.none, ingredients: []), livesCount: -1));

    Product tomato = Product(
        ingredient: Ingredient(ingredient: Ingredients.salad),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(color: Colors.white, meal: Meal(meal: Meals.none, ingredients: []), livesCount: -1));

    final defaultProducts = [tuna, bread, meat, salad, tomato];
    final products = <Product>[];

    int dimension = sqrt(size).toInt();
    var positions = getBoardPositionsList(dimension);

    final _random = Random();

    int count = 1;
    while(count <= dimension) {

      for(int i = 0; i < defaultProducts.length; i++) {
        Product product = defaultProducts[i];
        var pos = positions[_random.nextInt(positions.length)];
        product.position = pos;
        positions.remove(pos);
        products.add(product);
      }

      count++;
    }

    return products;
  }

  List<Cat> defaultCatsList() {
    final cats = <Cat>[];

    Cat blueCat = Cat(color: Colors.blue, meal: Meal(meal: Meals.none, ingredients: []), livesCount: 3);
    Cat greenCat = Cat(color: Colors.green, meal: Meal(meal: Meals.none, ingredients: []), livesCount: 3);
    Cat gingerCat = Cat(color: Colors.orange, meal: Meal(meal: Meals.none, ingredients: []), livesCount: 3);

    cats.add(blueCat);
    cats.add(gingerCat);
    cats.add(greenCat);

    return cats;
  }
}