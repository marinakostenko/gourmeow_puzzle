import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

class Utils {
  List<Product> shuffleProducts(int dimension, List<Product> products) {
    final shuffleProducts = <Product>[];
    final _random = Random();

    for (int y = 1; y <= dimension; y++) {
      for (int x = 1; x <= dimension; x++) {
        int randomIndex = _random.nextInt(products.length);

        var product = products.elementAt(randomIndex);

        product.position = BoardPosition(x: x, y: y);

        shuffleProducts.add(product);

        products.removeAt(randomIndex);
      }
    }

    return shuffleProducts;
  }

  List<Product> defaultProductsList(int size) {
    Product tuna = Product(
        ingredient: Ingredient(ingredient: Ingredients.tuna),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product bread = Product(
        ingredient: Ingredient(ingredient: Ingredients.bread),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product meat = Product(
        ingredient: Ingredient(ingredient: Ingredients.meat),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product salad = Product(
        ingredient: Ingredient(ingredient: Ingredients.salad),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product tomato = Product(
        ingredient: Ingredient(ingredient: Ingredients.tomato),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    final defaultProducts = [tuna, bread, meat, salad, tomato];
    final products = <Product>[];

    int row = 1;
    while (row <= size) {
      for (int i = 1; i <= defaultProducts.length; i++) {
        Product product = defaultProducts[i - 1].copyWith();
        product.position = BoardPosition(x: row, y: i);
        products.add(product);
      }

      row++;
    }

    for(Product product in products) {
      final h = identityHashCode(product);
      debugPrint(" $h ${product.position} + ${product.ingredient.ingredient.name}");
    }

    var shuffled = shuffleProducts(size, products);

    return shuffled;
  }

  List<Cat> defaultCatsList() {
    final cats = <Cat>[];

    Cat blueCat = Cat(
        color: Colors.blue,
        meal: Meal(meal: Meals.none, ingredients: []),
        livesCount: 3);
    Cat greenCat = Cat(
        color: Colors.green,
        meal: Meal(meal: Meals.none, ingredients: []),
        livesCount: 3);
    Cat gingerCat = Cat(
        color: Colors.orange,
        meal: Meal(meal: Meals.none, ingredients: []),
        livesCount: 3);

    cats.add(blueCat);
    cats.add(gingerCat);
    cats.add(greenCat);

    return cats;
  }
}
