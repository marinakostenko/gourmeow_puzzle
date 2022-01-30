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
import 'package:gourmeow_puzzle/puzzle/utils/utils.dart';

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
    productsList = Utils().defaultProductsList(event.size);

    cats = Utils().defaultCatsList();
    puzzle = Puzzle(products: productsList);

    puzzle = _setCatWishesPositions(puzzle, cats);

    emit(
      PuzzleState(
        puzzle: puzzle,
        count: 1,
        matchingProducts: const {},
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
        matchingProducts: {},
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

    Set<Product> dragNeighboursHorizontal =
        _createProductSet(true, event.dragProduct);
    Set<Product> dragNeighboursVertical =
        _createProductSet(false, event.dragProduct);

    Set<Ingredient> dragIngredientsHorizontal =
        _createIngredientSet(dragNeighboursHorizontal);
    Set<Ingredient> dragIngredientsVertical =
        _createIngredientSet(dragNeighboursVertical);

    Set<Product> matchingProducts = <Product>{};
    Meal meal = const Meal(meal: Meals.none);

    for (var pair in Utils().mealIngredients.entries) {
      var ingredients = pair.value;
      debugPrint("Meal set ${ingredients.toString()}");

      if (ingredients.difference(dragIngredientsHorizontal).isEmpty) {
        debugPrint(
            "Drag products horizontal set ${dragIngredientsHorizontal.toString()}");

        meal = pair.key;
        matchingProducts = dragNeighboursHorizontal;
        for (Product dropProduct in dragNeighboursHorizontal) {
          dropProduct.isSelected = true;
        }
      }
    }

    if (matchingProducts.isEmpty) {
      for (var pair in Utils().mealIngredients.entries) {
        var ingredients = pair.value;
        debugPrint("Meal set ${ingredients.toString()}");

        if (ingredients.difference(dragIngredientsVertical).isEmpty) {
          debugPrint("Drag products set ${dragIngredientsVertical.toString()}");

          meal = pair.key;
          matchingProducts = dragNeighboursVertical;

          for (Product dragProduct in dragNeighboursVertical) {
            dragProduct.isSelected = true;
          }
        }
      }
    }

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
        meal: meal,
        emptyProducts: {},
        emptyProductsMoved: false,
      ),
    );
  }

  Future<void> _onProductSelected(
      ProductSelected event, Emitter<PuzzleState> emit) async {
    debugPrint("Product selected state for meal ${event.meal}");
    int count = state.count;

    Meal meal = event.meal;
    Set<Product> matchingProduct = event.products;
    Set<Product> emptyProducts = {};

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

    puzzle = Puzzle(products: productsList);

    await Future.delayed(Duration(seconds: 1));

    debugPrint("count $count");
    count = count + 1;
    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: {},
        meal: const Meal(meal: Meals.none),
        emptyProducts: emptyProducts,
        emptyProductsMoved: false,
      ),
    );
  }

  Future<void> _onMoveEmptyProducts(
      MoveEmptyProducts event, Emitter<PuzzleState> emit) async {
    debugPrint(
        "Move empty products ${event.products.map((ingredient) => ingredient.ingredient)}");

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
          debugPrint(
              "not empty ${productsList[vertical][x].ingredient.ingredient} moving to $lastEmpty $x");

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
          debugPrint(
              "not empty ${productsList[vertical][x].ingredient.ingredient} moving to $lastEmpty $x");

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
        matchingProducts: {},
        meal: const Meal(meal: Meals.none),
        emptyProducts: emptyProductsUpdated,
        emptyProductsMoved: true,
      ),
    );
  }

  Future<void> _onFillEmptyProducts(
      FillEmptyProducts event, Emitter<PuzzleState> emit) async {
    debugPrint(
        "Fill empty products ${event.products.map((ingredient) => ingredient.ingredient)}");

    int count = state.count;
    count = count + 1;

    Set<Product> emptyProducts = event.products;
    
    for(Product product in emptyProducts) {
      int x = product.position.x - 1;
      int y = product.position.y - 1;

      debugPrint("old ingredient ${productsList[y][x].ingredient}");
      productsList[y][x].ingredient = Ingredient(ingredient: IngredientsExt.generateRandomIngredient());
      debugPrint("new ingredient ${productsList[y][x].ingredient}");
    }

    puzzle = Puzzle(products: productsList);

    await Future.delayed(Duration(seconds: 1));

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
        matchingProducts: {},
        meal: const Meal(meal: Meals.none),
        emptyProducts: {},
        emptyProductsMoved: false,
      ),
    );

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

  Set<Product> _createProductSet(bool horizontal, Product product) {
    Set<Product> products = {};

    int x = product.position.x - 1;
    int y = product.position.y - 1;

    if (horizontal) {
      if (x > 0 && x < productsList.length - 1) {
        products.add(productsList[y][x - 1]);
        products.add(productsList[y][x]);
        products.add(productsList[y][x + 1]);
        return products;
      }

      if (x == 0) {
        products.add(productsList[y][x]);
        products.add(productsList[y][x + 1]);
        products.add(productsList[y][x + 2]);
        return products;
      }

      if (x == productsList.length - 1) {
        products.add(productsList[y][x - 2]);
        products.add(productsList[y][x - 1]);
        products.add(productsList[y][x]);
        return products;
      }
    }

    if (!horizontal) {
      if (y > 0 && y < productsList.length - 1) {
        products.add(productsList[y + 1][x]);
        products.add(productsList[y][x]);
        products.add(productsList[y - 1][x]);
        return products;
      }

      if (y == 0) {
        products.add(productsList[y + 2][x]);
        products.add(productsList[y + 1][x]);
        products.add(productsList[y][x]);
        return products;
      }

      if (y == productsList.length - 1) {
        products.add(productsList[y][x]);
        products.add(productsList[y - 1][x]);
        products.add(productsList[y - 2][x]);
        return products;
      }
    }

    return products;
  }
}
