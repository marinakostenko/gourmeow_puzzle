import 'dart:collection';
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
    final List<List<Product>> sortedProducts = [];
    for (int y = 0; y < dimension; y++) {
      var productsList = <Product>[];
      for (int x = 0; x < dimension; x++) {
        Product product = products[y][x].copyWith();
        productsList.add(product);
      }
      sortedProducts.add(productsList);
    }

    final List<List<Product>> shuffleProducts = [];
    final _random = Random();

    for (int y = 1; y <= dimension; y++) {
      var shuffledX = <Product>[];
      for (int x = 1; x <= dimension; x++) {
        var currentProduct = sortedProducts[y - 1][x - 1];

        int randomY = _random.nextInt(products.length);
        int randomX = _random.nextInt(products[randomY].length);

        var product = products.elementAt(randomY).elementAt(randomX);

        product.position = BoardPosition(x: x, y: y);
        product.cat = currentProduct.cat;

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

  final Product defaultProduct = Product(
    ingredient: const Ingredient(ingredient: Ingredients.none),
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
      positions: [],
      image: const AssetImage("assets/images/default.png"),
    ),
  );

  List<Product> allProductsList() {
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
      positions: [],
      image: const AssetImage("assets/images/cats/american_cat.png"),
    );
    Cat greenCat = Cat(
      color: Colors.pinkAccent,
      meal: const Meal(meal: Meals.none),
      meals: [],
      livesCount: 3,
      cuisine: Cuisine.french,
      position: const BoardPosition(x: -1, y: -1),
      positions: [],
      image: const AssetImage("assets/images/cats/french_cat.png"),
    );
    Cat gingerCat = Cat(
      color: Colors.orange,
      meal: const Meal(meal: Meals.none),
      meals: [],
      livesCount: 3,
      cuisine: Cuisine.asian,
      position: const BoardPosition(x: -1, y: -1),
      positions: [],
      image: const AssetImage("assets/images/cats/asian_cat.png"),
    );

    cats.add(blueCat);
    cats.add(gingerCat);
    cats.add(greenCat);

    return cats;
  }

  Map<List<Cat>, List<List<Product>>> generateSolvableProductsList(int size) {
    List<List<Product>> products = [];
    List<Cat> catsReturn = [];
    for (int j = 1; j <= size; j++) {
      var productsList = <Product>[];
      for (int i = 1; i <= size; i++) {
        Product product =
            defaultProduct.copyWith(position: BoardPosition(x: i, y: j));
        productsList.add(product);
      }
      products.add(productsList);
    }

    List<Cat> cats = defaultCatsList();

    //5 to 5 -> 24 products 3 cats = 8 products -> 3 products 3 products 2 products
    var nums = <int>[10, 9, 6];

    //decide randomly which cat will have 2 and 3 meals
    Map<Cat, int> catsMap = {};
    final _random = Random();

    for (var cat in cats) {
      int index = _random.nextInt(nums.length);
      catsMap.putIfAbsent(cat, () => nums[index]);
      nums.removeAt(index);
    }

    var sortedKeys = catsMap.keys.toList(growable: false)
      ..sort((k1, k2) => catsMap[k1]!.compareTo(catsMap[k2]!));
    Map<Cat, int> sortedCatsMap = LinkedHashMap.fromIterable(sortedKeys,
        key: (k) => k, value: (k) => catsMap[k]!);

    //create board
    List<BoardPosition> corners = [
      const BoardPosition(x: 1, y: 1),
      const BoardPosition(x: 1, y: 5),
      const BoardPosition(x: 5, y: 1),
      const BoardPosition(x: 5, y: 5)
    ];

    int cornerIndex = _random.nextInt(corners.length);
    Map<int, List<BoardPosition>> positionsMap =
        _createBoard(corners[cornerIndex].x, corners[cornerIndex].y);
    debugPrint("Corner ${corners[cornerIndex]}");

    //assign meals for each cat from meals list
    for (var entry in sortedCatsMap.entries) {
      Cat cat = entry.key;
      int? count = entry.value;

      var meals = CuisineExt.getMealsByCuisine(cat.cuisine);
      var tmp = meals;
      int mealsCount = count ~/ 3;

      for (int i = 0; i < mealsCount; i++) {
        int index = _random.nextInt(tmp.length);
        cat.meals.add(Meal(meal: tmp.elementAt(index)));
        tmp.removeAt(index);
      }

      debugPrint("meals length ${cat.meals.length} cuisine ${cat.cuisine}");
      debugPrint("Count ${count} / ${mealsCount}");
      List<BoardPosition>? positions = positionsMap[count];

      cat.positions = positions!;

      List<Ingredient> ingredients = [];

      for (Meal meal in cat.meals) {
        for (var entry in mealIngredients.entries) {
          if (entry.value.meal == meal.meal) {
            ingredients.addAll(entry.key);
            break;
          }
        }
      }

      int index = 0;

      for (var position in positions) {
        int x = position.x;
        int y = position.y;

        if (index < ingredients.length) {
          products[y - 1][x - 1] = defaultProduct.copyWith(
            ingredient: ingredients[index],
            position: BoardPosition(x: x, y: y),
            cat: cat,
          );
          index++;
        }
      }

      catsReturn.add(cat);
    }

    var shuffled = shuffleProducts(size, products);

    return {catsReturn : shuffled};
  }

  Map<int, List<BoardPosition>> _createBoard(int x, int y) {
    Map<int, List<BoardPosition>> tiles = {};

    if (x == 1 && y == 1) {
      List<BoardPosition> tilesSixIngredients = [];

      for (int i = 1; i <= 2; i++) {
        for (int j = 1; j <= 3; j++) {
          tilesSixIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      tiles.putIfAbsent(6, () => tilesSixIngredients);

      List<BoardPosition> tilesNineIngredients = [];

      for (int i = 3; i <= 5; i++) {
        for (int j = 1; j <= 2; j++) {
          tilesNineIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int j = 3; j <= 5; j++) {
        tilesNineIngredients.add(BoardPosition(x: j, y: 5));
      }

      tiles.putIfAbsent(9, () => tilesNineIngredients);

      List<BoardPosition> tilesTenIngredients = [];

      for (int i = 1; i <= 3; i++) {
        for (int j = 4; j <= 5; j++) {
          tilesTenIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int j = 3; j <= 5; j++) {
        tilesTenIngredients.add(BoardPosition(x: j, y: 4));
      }

      tiles.putIfAbsent(10, () => tilesTenIngredients);
    }

    if (x == 1 && y == 5) {
      List<BoardPosition> tilesSixIngredients = [];

      for (int i = 3; i <= 5; i++) {
        for (int j = 1; j <= 2; j++) {
          tilesSixIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      tiles.putIfAbsent(6, () => tilesSixIngredients);

      List<BoardPosition> tilesNineIngredients = [];

      for (int i = 4; i <= 5; i++) {
        for (int j = 3; j <= 5; j++) {
          tilesNineIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int i = 1; i <= 3; i++) {
        tilesNineIngredients.add(BoardPosition(x: 5, y: i));
      }

      tiles.putIfAbsent(9, () => tilesNineIngredients);

      List<BoardPosition> tilesTenIngredients = [];

      for (int i = 1; i <= 2; i++) {
        for (int j = 1; j <= 3; j++) {
          tilesTenIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int i = 1; i <= 3; i++) {
        tilesTenIngredients.add(BoardPosition(x: 4, y: i));
      }

      tiles.putIfAbsent(10, () => tilesTenIngredients);
    }

    if (x == 5 && y == 1) {
      List<BoardPosition> tilesSixIngredients = [];

      for (int i = 1; i <= 3; i++) {
        for (int j = 4; j <= 5; j++) {
          tilesSixIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      tiles.putIfAbsent(6, () => tilesSixIngredients);

      List<BoardPosition> tilesNineIngredients = [];

      for (int i = 1; i <= 2; i++) {
        for (int j = 1; j <= 3; j++) {
          tilesNineIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int i = 3; i <= 5; i++) {
        tilesNineIngredients.add(BoardPosition(x: 1, y: i));
      }

      tiles.putIfAbsent(9, () => tilesNineIngredients);

      List<BoardPosition> tilesTenIngredients = [];

      for (int i = 4; i <= 5; i++) {
        for (int j = 3; j <= 5; j++) {
          tilesTenIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int i = 3; i <= 5; i++) {
        tilesTenIngredients.add(BoardPosition(x: 2, y: i));
      }

      tiles.putIfAbsent(10, () => tilesTenIngredients);
    }

    if (x == 5 && y == 5) {
      List<BoardPosition> tilesSixIngredients = [];

      for (int i = 4; i <= 5; i++) {
        for (int j = 3; j <= 5; j++) {
          tilesSixIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      tiles.putIfAbsent(6, () => tilesSixIngredients);

      List<BoardPosition> tilesNineIngredients = [];

      for (int i = 1; i <= 3; i++) {
        for (int j = 4; j <= 5; j++) {
          tilesNineIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int j = 1; j <= 3; j++) {
        tilesNineIngredients.add(BoardPosition(x: j, y: 1));
      }

      tiles.putIfAbsent(9, () => tilesNineIngredients);

      List<BoardPosition> tilesTenIngredients = [];

      for (int i = 3; i <= 5; i++) {
        for (int j = 1; j <= 2; j++) {
          tilesTenIngredients.add(BoardPosition(x: j, y: i));
        }
      }

      for (int j = 1; j <= 3; j++) {
        tilesTenIngredients.add(BoardPosition(x: j, y: 2));
      }

      tiles.putIfAbsent(10, () => tilesTenIngredients);
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
