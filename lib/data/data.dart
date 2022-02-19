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

  final Product _defaultProduct = Product(
    ingredient: const Ingredient(ingredient: Ingredients.rice),
    meal: const Meal(meal: Meals.none),
    position: const BoardPosition(x: -1, y: -1),
    isSelected: false,
    draggable: Drag.drag,
    cat: Cat(
      color: Colors.white,
      meal: const Meal(meal: Meals.none),
      meals: [],
      livesCount: -1,
      cuisine: Cuisine.none,
      position: const BoardPosition(x: -1, y: -1),
    ),
  );

  List<Product> allProductsList() {
    Product rice = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.rice));
    Product nori = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.nori));
    Product egg = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.egg));
    Product shrimps = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.shrimps));
    Product salmon = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.salmon));
    Product lettuce = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.lettuce));
    Product mango = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.mango));
    Product chicken = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.chicken));
    Product noodles = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.noodles));
    Product chilli = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.chilli));
    Product shiitake = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.shiitake));
    Product patty = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.patty));
    Product bun = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.bun));
    Product lobster = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.lobster));

    Product butter = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.butter));
    Product lemon = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.lemon));
    Product flour = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.flour));
    Product milk = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.milk));
    Product meat = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.meat));
    Product garlic = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.garlic));
    Product wine = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.wine));
    Product apple = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.apple));

    Product zucchini = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.zucchini));

    Product mussels = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.mussels));
    Product eggplant = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.eggplant));
    Product tomato = _defaultProduct.copyWith(
        ingredient: const Ingredient(ingredient: Ingredients.tomato));

    return [
      rice,
      nori,
      egg,
      shrimps,
      salmon,
      lettuce,
      mango,
      chicken,
      noodles,
      chilli,
      shiitake,
      patty,
      bun,
      lobster,
      butter,
      lemon,
      flour,
      milk,
      meat,
      garlic,
      wine,
      apple,
      zucchini,
      mussels,
      eggplant,
      tomato,
    ];
  }

  List<List<Product>> defaultProductsList(int size) {
    final Map<Ingredients, int> defaultProductsMap = {};
    final defaultProducts = allProductsList();

    for (var product in defaultProducts) {
      defaultProductsMap.putIfAbsent(product.ingredient.ingredient, () => 2);
    }

    List<List<Product>> productsTable = [];

    var _random = Random();

    for (int j = 1; j <= size; j++) {
      var products = <Product>[];
      for (int i = 1; i <= size; i++) {
        while (true) {
          int rand = _random.nextInt(defaultProducts.length - 1);
          Product product = defaultProducts[rand].copyWith();

          int count = defaultProductsMap[product.ingredient.ingredient]!;
          if (count > 0) {
            products.add(product);
            defaultProductsMap[product.ingredient.ingredient] = count - 1;
            break;
          }
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
      meal: const Meal(meal: Meals.none),
      meals: [],
      livesCount: 3,
      cuisine: Cuisine.american,
      position: const BoardPosition(x: -1, y: -1),
    );
    Cat greenCat = Cat(
      color: Colors.green,
      meal: const Meal(meal: Meals.none),
      meals: [],
      livesCount: 3,
      cuisine: Cuisine.french,
      position: const BoardPosition(x: -1, y: -1),
    );
    Cat gingerCat = Cat(
      color: Colors.orange,
      meal: const Meal(meal: Meals.none),
      meals: [],
      livesCount: 3,
      cuisine: Cuisine.asian,
      position: const BoardPosition(x: -1, y: -1),
    );

    cats.add(blueCat);
    cats.add(gingerCat);
    cats.add(greenCat);

    return cats;
  }

  List<List<Product>> generateSolvableProductsList(int size) {
    List<List<Product>> products = [];
    List<Cat> cats = defaultCatsList();

    //5 to 5 -> 24 products 3 cats = 8 products -> 3 products 3 products 2 products
    var nums = <int>[10, 9, 2];

    //decide randomly which cat will have 2 and 3 meals
    Map<Cat, int> catsMap = {};
    final _random = Random();

    for (var cat in cats) {
      int index = nums.elementAt(_random.nextInt(nums.length - 1));
      catsMap.putIfAbsent(cat, () => nums[index]);
      nums.removeAt(index);
    }

    //create board
    List<BoardPosition> corners = [
      const BoardPosition(x: 1, y: 1),
      const BoardPosition(x: 1, y: 5),
      const BoardPosition(x: 5, y: 1),
      const BoardPosition(x: 5, y: 5)
    ];

    //assign meals for each cat from meals list
    for (Cat cat in cats) {
      var meals = CuisineExt.getMealsByCuisine(cat.cuisine);
      int? count = catsMap[cat];

      for (int i = 0; i < count! % 3; i++) {
        int index = _random.nextInt(meals.length - 1);
        cat.meals.add(Meal(meal: meals.elementAt(index)));
        meals.removeAt(index);
      }

      int cornerIndex = _random.nextInt(corners.length - 1);
      List<BoardPosition> positions = generatePatterns(
          corners[cornerIndex].x, corners[cornerIndex].y, count);
      corners.removeAt(cornerIndex);

      List<Ingredient> ingredients = [];

      for (Meals meal in meals) {
        for (var entry in mealIngredients.entries) {
          if (entry.value.meal == meal) {
            ingredients.addAll(entry.key);
            break;
          }
        }
      }

      int index = 0;

      positions.forEach((position) {
        int x = position.x;
        int y = position.y;

        if(index < ingredients.length) {
          products[y - 1][x - 1] = _defaultProduct.copyWith(
            ingredient: ingredients[index],
            position: position,
            cat: cat,
          );
        } else {
          products[y - 1][x - 1] = _defaultProduct.copyWith();
        }
      });
    }

    return products;
  }

  List<BoardPosition> generatePatterns(int x, int y, int elementsCount) {
    switch (elementsCount) {
      case 6:
        return _createPositions(x, y, 3, 2);
      case 9:
        return _createPositions(x, y, 3, 3);
      case 10:
        return _createPositions(x, y, 2, 5);
      default:
        return [];
    }
  }

  List<BoardPosition> _createPositions(
      int x, int y, int horizontalCount, int verticalCount) {
    List<BoardPosition> tiles = [];
    if (x == 1 && y == 1) {
      for (int i = 1; i <= verticalCount; i++) {
        for (int j = 1; j <= horizontalCount; j++) {
          tiles.add(BoardPosition(x: j, y: i));
        }
      }
    } else if (x == 1 && y == 5) {
      for (int i = 6 - verticalCount; i <= 5; i++) {
        for (int j = 1; j <= horizontalCount; j++) {
          tiles.add(BoardPosition(x: j, y: i));
        }
      }
    } else if (x == 5 && y == 1) {
      for (int i = 1; i <= verticalCount; i++) {
        for (int j = 6 - horizontalCount; j <= 5; j++) {
          tiles.add(BoardPosition(x: j, y: i));
        }
      }
    } else if (x == 5 && y == 5) {
      for (int i = 6 - verticalCount; i <= 5; i++) {
        for (int j = 6 - horizontalCount; j <= 5; j++) {
          tiles.add(BoardPosition(x: j, y: i));
        }
      }
    }

    return tiles;
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
      Recipe recipe = Recipe(
          meal: value.meal,
          mealImage: value.meal.mealImage,
          ingredientsImages: ingredientImages);
      recipes.add(recipe);
    });

    return recipes;
  }
}
