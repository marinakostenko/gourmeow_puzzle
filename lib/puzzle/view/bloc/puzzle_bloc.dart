import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/models/puzzle.dart';
import 'package:gourmeow_puzzle/puzzle/utils/data.dart';

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

    debugPrint("drag count $count");
    puzzle = Puzzle(products: productsList);

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: [],
        meal: const Meal(meal: Meals.none),
        emptyProducts: {},
        emptyProductsMoved: false,
      ),
    );
  }

  void _onProductDropped(ProductDropped event, Emitter<PuzzleState> emit) {
    int count = state.count;

    debugPrint(
        "Product to drop ${event.dragProduct.ingredient.ingredient.name}");

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

        debugPrint("Before sort ${matchingProduct.map((product) => product.ingredient.ingredient.name)}");
        matchingProduct.toList().sort((product1, product2) =>
            product1.position.compareTo(product2.position));

        debugPrint("After sort ${matchingProduct.map((product) => product.ingredient.ingredient.name)}");


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

    debugPrint("count $count");
    count = count + 1;
    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: [],
        meal: const Meal(meal: Meals.none),
        emptyProducts: emptyProducts,
        emptyProductsMoved: false,
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
      ),
    );
  }

  Future<void> _onFillEmptyProducts(
      FillEmptyProducts event, Emitter<PuzzleState> emit) async {
    int count = state.count;
    count = count + 1;

    Set<Product> emptyProducts = event.products;

    for (Product product in emptyProducts) {
      int x = product.position.x - 1;
      int y = product.position.y - 1;

      productsList[y][x].ingredient =
          Ingredient(ingredient: IngredientsExt.generateRandomIngredient());
    }

    var matchingProducts = _checkBoardOnMealsExistence();
    debugPrint(matchingProducts
        .map((set) =>
            set.map((product) => product.ingredient.ingredient.name).toString())
        .toString());

    puzzle = Puzzle(products: productsList);

    await Future.delayed(Duration(seconds: 1));

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: matchingProducts,
        meal: const Meal(meal: Meals.none),
        emptyProducts: {},
        emptyProductsMoved: false,
      ),
    );
  }

  List<Set<Product>> _checkBoardOnMealsExistence() {
    List<Set<Product>> mealsOnBoard = [];

    for (int y = 0; y < productsList.length; y++) {
      for (int x = 0; x < productsList[0].length; x++) {
        //horizontal check
        if (x < 3) {
          Set<Product> horizontalProducts = {};
          int count = 0;
          while (count < 3) {
            Product product = productsList[y][x + count];
            if (!product.isSelected &&
                product.ingredient.ingredient != Ingredients.none) {
              horizontalProducts.add(product);
              count++;
            } else {
              break;
            }
          }

          if (horizontalProducts.length == 3) {
            var horizontalIngredients =
                _createIngredientSet(horizontalProducts);

            for (var ingredients in Data().mealIngredients.keys) {
              if (ingredients.difference(horizontalIngredients).isEmpty) {
                debugPrint(
                    "Products set horizontal ${horizontalProducts.map((product) => product.ingredient.ingredient.name + "${product.position.y} + ${product.position.x}")}");

                for (Product product in horizontalProducts) {
                  int x = product.position.x - 1;
                  int y = product.position.y - 1;

                  productsList[y][x].isSelected = true;
                }
                mealsOnBoard.add(horizontalProducts);
              }
            }
          }
        }
      }
    }

    for (int y = 0; y < productsList.length; y++) {
      for (int x = 0; x < productsList[0].length; x++) {
        //vertical check
        if (y < 3) {
          Set<Product> verticalProducts = {};
          int count = 0;
          while (count < 3) {
            Product product = productsList[y + count][x];
            if (!product.isSelected &&
                product.ingredient.ingredient != Ingredients.none) {
              verticalProducts.add(product);
            } else {
              break;
            }
            count++;
          }

          if (verticalProducts.length == 3) {
            var verticalIngredients = _createIngredientSet(verticalProducts);

            for (var ingredients in Data().mealIngredients.keys) {
              if (ingredients.difference(verticalIngredients).isEmpty) {
                debugPrint(
                    "Products set vertical ${verticalProducts.map((product) => product.ingredient.ingredient.name + "${product.position.y} + ${product.position.x}")}");

                for (Product product in verticalProducts) {
                  int x = product.position.x - 1;
                  int y = product.position.y - 1;

                  productsList[y][x].isSelected = true;
                }
                mealsOnBoard.add(verticalProducts);
              }
            }
          }
        }
      }
    }

    return mealsOnBoard;
  }

  Puzzle _setCatWishesPositions(Puzzle puzzle, List<Cat> cats) {
    //TODO add random dishes to selected cats

    final _random = Random();

    for (Cat cat in cats) {
      while (true) {
        var product = puzzle.products
            .elementAt(_random.nextInt(puzzle.products.length))
            .elementAt(_random.nextInt(puzzle.products[0].length));

        if (product.cat.color == Colors.white) {
          product.cat = cat;
          break;
        }
      }
    }

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
