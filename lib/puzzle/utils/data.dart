import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

class Data {
  List<List<Product>> shuffleProducts(
      int dimension, List<List<Product>> products) {
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
        if (products.elementAt(randomY).isEmpty) {
          products.removeAt(randomY);
        }
      }
      shuffleProducts.add(shuffledX);
    }

    return shuffleProducts;
  }

  List<List<Product>> defaultProductsList(int size) {
    Product defaultProduct = Product(
        ingredient: const Ingredient(ingredient: Ingredients.rise),
        meal: const Meal(meal: Meals.none),
        position: const BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
            color: Colors.white,
            meal: Meal(meal: Meals.none),
            livesCount: -1,
            cuisine: Cuisine.none));

    Product tuna = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.tuna));
    Product bread = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.bread));
    Product meat = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.meat));
    Product salad = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.salad));
    Product tomato = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.tomato));
    Product bun = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.bun));
    Product avocado = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.avocado));
    Product croutons = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.croutons));
    Product cheese = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.cheese));
    Product onion = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.onion));
    Product rise = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.rise));
    Product nori = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.nori));
    Product shrimps = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.shrimps));
    Product egg = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.egg));

    final defaultProducts = [
      tuna,
      bread,
      meat,
      salad,
      tomato,
      bun,
      avocado,
      croutons,
      cheese,
      onion,
      rise,
      nori,
      shrimps,
      egg
    ];

    List<List<Product>> productsTable = [];

    int defaultCount = 0;

    for (int j = 1; j <= size; j++) {
      var products = <Product>[];
      for (int i = 1; i <= size; i++) {
        if (defaultCount < defaultProducts.length) {
          Product product = defaultProducts[defaultCount].copyWith();
          products.add(product);
          defaultCount++;
        }

        if (defaultCount == defaultProducts.length) {
          defaultCount = 0;
        }
      }

      productsTable.add(products);
    }

    var shuffled = shuffleProducts(size, productsTable);

    // for(List<Product> productsList in shuffled) {
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
        meal: Meal(meal: Meals.none),
        livesCount: 3,
        cuisine: Cuisine.american);
    Cat greenCat = Cat(
        color: Colors.green,
        meal: Meal(meal: Meals.none),
        livesCount: 3,
        cuisine: Cuisine.french);
    Cat gingerCat = Cat(
        color: Colors.orange,
        meal: Meal(meal: Meals.none),
        livesCount: 3,
        cuisine: Cuisine.asian);

    cats.add(blueCat);
    cats.add(gingerCat);
    cats.add(greenCat);

    return cats;
  }

  Map<Set<Ingredient>, Meal> mealIngredients = {
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.salad),
      const Ingredient(ingredient: Ingredients.onion),
      const Ingredient(ingredient: Ingredients.tuna)
    }: const Meal(meal: Meals.tunaSalad),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.salad),
      const Ingredient(ingredient: Ingredients.tomato),
      const Ingredient(ingredient: Ingredients.avocado)
    }: const Meal(meal: Meals.vegetableSalad),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.bread),
      const Ingredient(ingredient: Ingredients.tomato),
      const Ingredient(ingredient: Ingredients.cheese)
    }: const Meal(meal: Meals.sandwich),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.bun),
      const Ingredient(ingredient: Ingredients.salad),
      const Ingredient(ingredient: Ingredients.meat)
    }: const Meal(meal: Meals.burger),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.croutons),
      const Ingredient(ingredient: Ingredients.salad),
      const Ingredient(ingredient: Ingredients.meat)
    }: const Meal(meal: Meals.cesar),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.egg),
      const Ingredient(ingredient: Ingredients.rise),
      const Ingredient(ingredient: Ingredients.shrimps)
    }: const Meal(meal: Meals.eggRise),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.tuna),
      const Ingredient(ingredient: Ingredients.rise),
      const Ingredient(ingredient: Ingredients.nori)
    }: const Meal(meal: Meals.tunaRoll),
  };
}
