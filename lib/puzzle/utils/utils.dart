import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

class Utils {
  List<List<Product>> shuffleProducts(int dimension, List<List<Product>> products) {
    final List<List<Product>> shuffleProducts = [];
    final _random = Random();

    for (int y = 1; y <= dimension; y++) {
      var shuffledX = <Product>[];
      for (int x = 1; x <= dimension; x++) {
        int randomY = _random.nextInt(products.length);
        int randomX = _random.nextInt(products[randomY].length);


        var product = products.elementAt(randomY).elementAt(randomX);

        product.position = BoardPosition(x: x, y: y);

        shuffledX.add(product);

        products.elementAt(randomY).removeAt(randomX);
        if(products.elementAt(randomY).isEmpty) {
          products.removeAt(randomY);
        }
      }
      shuffleProducts.add(shuffledX);
    }

    return shuffleProducts;
  }

  List<List<Product>> defaultProductsList(int size) {
    Product tuna = Product(
        ingredient: Ingredient(ingredient: Ingredients.tuna),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product bread = Product(
        ingredient: Ingredient(ingredient: Ingredients.bread),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product meat = Product(
        ingredient: Ingredient(ingredient: Ingredients.meat),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product salad = Product(
        ingredient: Ingredient(ingredient: Ingredients.salad),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    Product tomato = Product(
        ingredient: Ingredient(ingredient: Ingredients.tomato),
        meal: Meal(meal: Meals.none, ingredients: []),
        position: BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none, ingredients: []),
            livesCount: -1));

    final defaultProducts = [tuna, bread, meat, salad, tomato];

    List<List<Product>> productsTable = [];

    for(int j = 1; j <= size; j++) {
      var products = <Product>[];
      for (int i = 1; i <= defaultProducts.length; i++) {
        Product product = defaultProducts[i - 1].copyWith();
      //  product.position = BoardPosition(x: j, y: i);
        products.add(product);
      }

      productsTable.add(products);
    }

    var shuffled = shuffleProducts(size, productsTable);

    // for(List<Product> productsList in productsTable) {
    //   for(Product product in productsList) {
    //     final h = identityHashCode(product);
    //     debugPrint(" $h ${product.position} + ${product.ingredient.ingredient.name}");
    //   }
    // }

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
