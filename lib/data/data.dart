import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/models/recipe.dart';

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
        ingredient: const Ingredient(ingredient: Ingredients.rice),
        meal: const Meal(meal: Meals.none),
        position: const BoardPosition(x: -1, y: -1),
        isSelected: false,
        draggable: Drag.drag,
        cat: Cat(
          color: Colors.white,
          meal: const Meal(meal: Meals.none),
          livesCount: -1,
          cuisine: Cuisine.none,
          position: const BoardPosition(x: -1, y: -1),
        ));

    Product rice = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.rice));
    Product nori = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.nori));
    Product egg = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.egg));
    Product shrimps = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.shrimps));
    Product salmon = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.salmon));
    Product lettuce = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.lettuce));
    Product mango = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.mango));
    Product chicken = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.chicken));
    Product noodles = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.noodles));
    Product chilli = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.chilli));
    Product shiitake = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.shiitake));
    Product patty = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.patty));
    Product bun = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.bun));
    Product lobster = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.lobster));

    Product butter = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.butter));
    Product lemon = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.lemon));
    Product flour = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.flour));
    Product milk = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.milk));
    Product meat = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.meat));
    Product garlic = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.garlic));
    Product wine = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.wine));
    Product apple = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.apple));

    Product zucchini = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.zucchini));

    Product mussels = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.mussels));
    Product eggplant = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.eggplant));
    Product tomato = defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.tomato));

    final defaultProducts = [
      rice,
      rice,
      nori,
      egg,
      egg,
      egg,
      shrimps,
      shrimps,
      salmon,
      salmon,
      lettuce,
      lettuce,
      mango,
      chicken,
      chicken,
      noodles,
      noodles,
      chilli,
      shiitake,
      patty,
      bun,
      lobster,
      butter,
      butter,
      butter,
      lemon,
      lemon,
      flour,
      flour,
      flour,
      flour,
      milk,
      meat,
      garlic,
      garlic,
      wine,
      wine,
      apple,
      zucchini,
      zucchini,
      mussels,
      eggplant,
      tomato,
    ];

    List<List<Product>> productsTable = [];

    var _random = Random();

    for (int j = 1; j <= size; j++) {
      var products = <Product>[];
      for (int i = 1; i <= size; i++) {
        int rand = _random.nextInt(defaultProducts.length - 1);
        Product product = defaultProducts[rand].copyWith();
        products.add(product);
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
      meal: const Meal(meal: Meals.none),
      livesCount: 3,
      cuisine: Cuisine.american,
      position: const BoardPosition(x: -1, y: -1),
    );
    Cat greenCat = Cat(
      color: Colors.green,
      meal: const Meal(meal: Meals.none),
      livesCount: 3,
      cuisine: Cuisine.french,
      position: const BoardPosition(x: -1, y: -1),
    );
    Cat gingerCat = Cat(
      color: Colors.orange,
      meal: const Meal(meal: Meals.none),
      livesCount: 3,
      cuisine: Cuisine.asian,
      position: const BoardPosition(x: -1, y: -1),
    );

    cats.add(blueCat);
    cats.add(gingerCat);
    cats.add(greenCat);

    return cats;
  }

  Map<Set<Ingredient>, Meal> mealIngredients = {
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.egg),
      const Ingredient(ingredient: Ingredients.rice),
      const Ingredient(ingredient: Ingredients.shrimps)
    }: const Meal(meal: Meals.eggRice),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.salmon),
      const Ingredient(ingredient: Ingredients.rice),
      const Ingredient(ingredient: Ingredients.nori)
    }: const Meal(meal: Meals.sushi),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.mango),
      const Ingredient(ingredient: Ingredients.lettuce),
      const Ingredient(ingredient: Ingredients.shrimps)
    }: const Meal(meal: Meals.mangoSalad),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.chicken),
      const Ingredient(ingredient: Ingredients.noodles),
      const Ingredient(ingredient: Ingredients.chilli)
    }: const Meal(meal: Meals.pho),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.shiitake),
      const Ingredient(ingredient: Ingredients.noodles),
      const Ingredient(ingredient: Ingredients.chicken)
    }: const Meal(meal: Meals.friedNoodles),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.patty),
      const Ingredient(ingredient: Ingredients.lettuce),
      const Ingredient(ingredient: Ingredients.bun)
    }: const Meal(meal: Meals.burger),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.lobster),
      const Ingredient(ingredient: Ingredients.lemon),
      const Ingredient(ingredient: Ingredients.butter)
    }: const Meal(meal: Meals.lobsterTail),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.flour),
      const Ingredient(ingredient: Ingredients.milk),
      const Ingredient(ingredient: Ingredients.egg)
    }: const Meal(meal: Meals.pancakes),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.meat),
      const Ingredient(ingredient: Ingredients.wine),
      const Ingredient(ingredient: Ingredients.garlic)
    }: const Meal(meal: Meals.steak),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.flour),
      const Ingredient(ingredient: Ingredients.apple),
      const Ingredient(ingredient: Ingredients.butter)
    }: const Meal(meal: Meals.applePie),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.flour),
      const Ingredient(ingredient: Ingredients.butter),
      const Ingredient(ingredient: Ingredients.egg)
    }: const Meal(meal: Meals.croissant),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.salmon),
      const Ingredient(ingredient: Ingredients.lemon),
      const Ingredient(ingredient: Ingredients.zucchini)
    }: const Meal(meal: Meals.bakedSalmon),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.mussels),
      const Ingredient(ingredient: Ingredients.wine),
      const Ingredient(ingredient: Ingredients.garlic)
    }: const Meal(meal: Meals.moules),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.zucchini),
      const Ingredient(ingredient: Ingredients.eggplant),
      const Ingredient(ingredient: Ingredients.tomato)
    }: const Meal(meal: Meals.ratatouille),
    <Ingredient>{
      const Ingredient(ingredient: Ingredients.chicken),
      const Ingredient(ingredient: Ingredients.butter),
      const Ingredient(ingredient: Ingredients.apple)
    }: const Meal(meal: Meals.chickenInCider),
  };

  List<Recipe> recipesList() {
    List<Recipe> recipes = [];

    mealIngredients.forEach((key, value) {
      List<AssetImage> ingredientImages = [];
      for (var element in key) {
        ingredientImages.add(element.ingredient.ingredientImage);
      }
      Recipe recipe = Recipe(meal: value.meal, mealImage: value.meal.mealImage, ingredientsImages: ingredientImages);
      recipes.add(recipe);
    });

    return recipes;
  }
}
