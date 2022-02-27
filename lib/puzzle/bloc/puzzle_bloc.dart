import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/models/puzzle.dart';
import 'package:gourmeow_puzzle/data/data.dart';
import 'package:gourmeow_puzzle/timer/bloc/timer_bloc.dart';

part 'puzzle_event.dart';

part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<ProductDropped>(_onProductDropped);
    on<ProductDragged>(_onProductDragged);
    on<ProductSelected>(_onProductSelected);
    on<MoveEmptyProducts>(_onMoveEmptyProducts);
    on<FillEmptyProducts>(_onFillEmptyProducts);
    on<TimeEnded>(_onTimeEnded);
  }

  List<List<Product>> productsList = [];
  List<Cat> cats = [];
  Puzzle puzzle = const Puzzle(products: []);

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    debugPrint("initialized");
    productsList = Data().defaultProductsList(event.size);

    cats = Data().defaultCatsList();
    puzzle = Puzzle(products: productsList);

    var matchingProducts = _checkBoardOnMealsExistence();
    debugPrint(matchingProducts
        .map((set) =>
            set.map((product) => product.ingredient.ingredient.name).toString())
        .toString());

    puzzle = _setCatWishesPositions(puzzle, cats);

    emit(
      PuzzleState(
        puzzle: puzzle,
        count: 1,
        matchingProducts: matchingProducts,
        cats: cats,
        gameFinished: false,
      ),
    );
  }

  void _onProductDragged(ProductDragged event, Emitter<PuzzleState> emit) {
    debugPrint("Product dragged ${event.product.ingredient.ingredient.name}");

    int count = state.count;
    count = count + 1;

    int xProduct = event.product.position.x - 1;
    int yProduct = event.product.position.y - 1;

    if (xProduct > 0) {
      //left
      productsList[yProduct][xProduct - 1].draggable = Drag.drop;
    }

    if (xProduct < productsList.length - 1) {
      //right
      productsList[yProduct][xProduct + 1].draggable = Drag.drop;
    }

    if (yProduct > 0) {
      //bottom
      productsList[yProduct - 1][xProduct].draggable = Drag.drop;
    }

    if (yProduct < productsList.length - 1) {
      //top
      productsList[yProduct + 1][xProduct].draggable = Drag.drop;
    }

    puzzle = Puzzle(products: productsList);

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: [],
        meal: const Meal(meal: Meals.none),
        emptyProducts: {},
        emptyProductsMoved: false,
        cats: cats,
      ),
    );
  }

  void _onProductDropped(ProductDropped event, Emitter<PuzzleState> emit) {
    int count = state.count;

    Cat dragCat = event.dragProduct.cat;
    Cat dropCat = event.dropProduct.cat;

    int yProduct = event.dragProduct.position.y;
    int xProduct = event.dragProduct.position.x;

    event.dragProduct.position = event.dropProduct.position;

    productsList[event.dropProduct.position.y - 1]
        [event.dropProduct.position.x - 1] = event.dragProduct;

    productsList[yProduct - 1][xProduct - 1] = event.dropProduct;
    event.dropProduct.position = BoardPosition(x: xProduct, y: yProduct);

    bool switched = false;
    if (dragCat.color != Colors.white) {
      event.dropProduct.cat = dragCat;
      event.dragProduct.cat = dropCat;
      switched = true;
    }

    if (dropCat.color != Colors.white && !switched) {
      event.dragProduct.cat = dropCat;
      event.dropProduct.cat = dragCat;
    }

    var matchingProducts = _checkBoardOnMealsExistence();
    debugPrint(matchingProducts
        .map((set) =>
            set.map((product) => product.ingredient.ingredient.name).toString())
        .toString());

    for (List<Product> products in productsList) {
      for (Product product in products) {
        product.draggable = Drag.drag;
      }
    }

    puzzle = Puzzle(products: productsList);

    debugPrint("count $count");
    count = count + 1;
    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: matchingProducts,
        emptyProducts: {},
        emptyProductsMoved: false,
        cats: cats,
      ),
    );
  }

  void _onTimeEnded(TimeEnded event, Emitter<PuzzleState> emit) {
    int count = state.count;

    List<Cat> cats = event.cats;
    Set<Product> emptyProducts = {};
    bool gameFinished = false;

    for (Cat cat in cats) {
      Meal expected = cat.meal;

      Product product = productsList[cat.position.y - 1][cat.position.x - 1];
      Meal real = product.meal;
      int livesCount = cat.livesCount;

      if (expected.meal != real.meal) {
        cat.livesCount = livesCount - 1;
      } else {
        cat.livesCount = 3;
      }

      if (cat.livesCount == 0) {
        gameFinished = true;
      }

      cat.position = const BoardPosition(x: -1, y: -1);
      cat.meal = const Meal(meal: Meals.none);

      product.meal = const Meal(meal: Meals.none);
      product.ingredient = const Ingredient(ingredient: Ingredients.none);
      product.isSelected = false;
      product.cat = Cat(
        color: Colors.white,
        meal: const Meal(meal: Meals.none),
        meals: [],
        servedMeals: [],
        livesCount: -1,
        cuisine: Cuisine.none,
        position: const BoardPosition(x: -1, y: -1),
        positions: [],
        image: const AssetImage("assets/images/default.png"),
      );

      emptyProducts.add(product);
    }

    puzzle = Puzzle(products: productsList);
    this.cats = cats;

    bool updateCats = gameFinished ? false : true;

    debugPrint("count $count");
    count = count + 1;
    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: [],
        emptyProducts: emptyProducts,
        emptyProductsMoved: false,
        cats: cats,
        updateCats: updateCats,
        gameFinished: gameFinished,
      ),
    );
  }

  Future<void> _onProductSelected(
      ProductSelected event, Emitter<PuzzleState> emit) async {
    int count = state.count;
    Set<Product> emptyProducts = {};

    for (var products in event.products) {
      Set<Ingredient> ingredients = {};

      for (var product in products) {
        ingredients.add(product.ingredient);
      }

      Meal meal = const Meal(meal: Meals.none);

      for (var pair in Data().mealIngredients.entries) {
        if (pair.key.difference(ingredients).isEmpty) {
          meal = pair.value;
          break;
        }
      }

      if (meal.meal != Meals.none) {
        Set<Product> matchingProduct = products;

        debugPrint("Product selected state for meal $meal");

        for (int i = 0; i < matchingProduct.length; i++) {
          Product product = matchingProduct.elementAt(i);

          int x = product.position.x - 1;
          int y = product.position.y - 1;

          productsList[y][x].ingredient =
              const Ingredient(ingredient: Ingredients.none);
          productsList[y][x].isSelected = false;

          if (i == 0) {
            productsList[y][x].meal = meal;
          } else {
            emptyProducts.add(product);
          }
        }
      }
    }

    puzzle = Puzzle(products: productsList);

    await Future.delayed(Duration(seconds: 1));

    count = count + 1;
    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: [],
        meal: const Meal(meal: Meals.none),
        emptyProducts: emptyProducts,
        emptyProductsMoved: false,
        cats: cats,
      ),
    );
  }

  Future<void> _onMoveEmptyProducts(
      MoveEmptyProducts event, Emitter<PuzzleState> emit) async {
    int count = state.count;
    count = count + 1;

    Set<Product> emptyProducts = event.products;
    Set<Product> emptyProductsUpdated = event.products;

    for (Product product in emptyProducts) {
      int x = product.position.x - 1;
      int y = product.position.y - 1;

      int vertical = y;
      int lastEmpty = y;

      while (vertical >= 0) {
        if (productsList[vertical][x].ingredient.ingredient !=
            Ingredients.none) {
          productsList[lastEmpty][x].ingredient =
              productsList[vertical][x].ingredient;
          productsList[vertical][x].ingredient =
              const Ingredient(ingredient: Ingredients.none);

          emptyProductsUpdated = emptyProductsUpdated
              .map((product) => product == productsList[lastEmpty][x]
                  ? productsList[vertical][x]
                  : product)
              .toSet();

          lastEmpty = vertical;
        }

        if (productsList[vertical][x].meal.meal != Meals.none) {
          productsList[lastEmpty][x].meal = productsList[vertical][x].meal;
          productsList[vertical][x].meal = const Meal(meal: Meals.none);

          emptyProductsUpdated = emptyProductsUpdated
              .map((product) => product == productsList[lastEmpty][x]
                  ? productsList[vertical][x]
                  : product)
              .toSet();

          lastEmpty = vertical;
        }

        vertical--;
      }
    }

    puzzle = Puzzle(products: productsList);

    await Future.delayed(Duration(seconds: 1));

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: [],
        meal: const Meal(meal: Meals.none),
        emptyProducts: emptyProductsUpdated,
        emptyProductsMoved: true,
        cats: cats,
      ),
    );
  }

  Future<void> _onFillEmptyProducts(
      FillEmptyProducts event, Emitter<PuzzleState> emit) async {
    int count = state.count;
    count = count + 1;

    Set<Product> emptyProducts = event.products;

    List<Ingredient> ingredients = [];
    for (int i = 0; i < productsList.length; i++) {
      for (int j = 0; j < productsList[0].length; j++) {
        ingredients.add(productsList[i][j].ingredient);
      }
    }

    for (Product product in emptyProducts) {
      int x = product.position.x - 1;
      int y = product.position.y - 1;

      productsList[y][x].ingredient = Ingredient(
          ingredient: IngredientsExt.generateRandomIngredient(ingredients));
    }

    var matchingProducts = _checkBoardOnMealsExistence();
    debugPrint(matchingProducts
        .map((set) =>
            set.map((product) => product.ingredient.ingredient.name).toString())
        .toString());

    puzzle = Puzzle(products: productsList);

    bool updateCats = event.updateCats;

    if (matchingProducts.isEmpty && event.updateCats) {
      puzzle = _setCatWishesPositions(puzzle, event.cats);
      updateCats = false;
    }

    await Future.delayed(Duration(seconds: 1));

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: matchingProducts,
        meal: const Meal(meal: Meals.none),
        emptyProducts: {},
        emptyProductsMoved: false,
        cats: cats,
        updateCats: updateCats,
      ),
    );
  }

  List<Set<Product>> _checkBoardOnMealsExistence() {
    List<Set<Product>> mealsOnBoard = [];

    List<Set<Product>> horizontalMeals = _checkLayout(Layout.horizontal);
    List<Set<Product>> verticalMeals = _checkLayout(Layout.vertical);

    mealsOnBoard = horizontalMeals + verticalMeals;

    return mealsOnBoard;
  }

  List<Set<Product>> _checkLayout(Layout layout) {
    List<Set<Product>> mealsOnBoardByLayout = [];

    for (int y = 0; y < productsList.length; y++) {
      for (int x = 0; x < productsList[0].length; x++) {
        int variable = (layout == Layout.horizontal) ? x : y;
        int xCount = 0;
        int yCount = 0;

        if (variable < 4) {
          Set<Product> products = {};
          while (xCount < 3 && yCount < 3) {
            Product product = productsList[y + yCount][x + xCount];
            if (!product.isSelected &&
                product.ingredient.ingredient != Ingredients.none) {
              products.add(product);

              (layout == Layout.horizontal) ? xCount++ : yCount++;
            } else {
              break;
            }
          }

          if (products.length == 3) {
            var currIngredients = _createIngredientSet(products);

            for (var ingredients in Data().mealIngredients.keys) {
              if (ingredients.difference(currIngredients).isEmpty) {
                debugPrint(
                    "Products set ${layout.name} ${products.map((product) => product.ingredient.ingredient.name + "${product.position.y} + ${product.position.x}")}");

                for (Product product in products) {
                  int x = product.position.x - 1;
                  int y = product.position.y - 1;

                  productsList[y][x].isSelected = true;
                }
                mealsOnBoardByLayout.add(products);
              }
            }
          }
        }
      }
    }

    return mealsOnBoardByLayout;
  }

  Puzzle _setCatWishesPositions(Puzzle puzzle, List<Cat> cats) {
    final _random = Random();

    for (Cat cat in cats) {
      var meals = CuisineExt.getMealsByCuisine(cat.cuisine);
      cat.meal = Meal(meal: meals.elementAt(_random.nextInt(meals.length)));

      while (true) {
        var product = puzzle.products
            .elementAt(_random.nextInt(puzzle.products.length))
            .elementAt(_random.nextInt(puzzle.products[0].length));

        if (product.cat.color == Colors.white) {
          product.cat = cat;
          cat.position = product.position;
          break;
        }
      }
    }

    this.cats = cats;

    return puzzle;
  }

  Set<Ingredient> _createIngredientSet(Set<Product> products) {
    Set<Ingredient> ingredients = {};

    for (Product product in products) {
      ingredients.add(product.ingredient);
    }

    return ingredients;
  }
}
