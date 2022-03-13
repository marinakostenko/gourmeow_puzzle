import 'dart:collection';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:gourmeow_puzzle/data/data.dart';
import 'package:gourmeow_puzzle/helpers/product_helper.dart';
import 'package:gourmeow_puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/models/puzzle.dart';

part 'slide_puzzle_event.dart';

part 'slide_puzzle_state.dart';

class SlidePuzzleBloc extends Bloc<SlidePuzzleEvent, SlidePuzzleState> {
  SlidePuzzleBloc() : super(const SlidePuzzleState()) {
    on<SlidePuzzleInitialized>(_onSlidePuzzleInitialized);
    on<ProductTapped>(_onProductTapped);
  }

  List<List<Product>> productsList = [];
  List<Cat> cats = [];
  Puzzle puzzle = const Puzzle(products: []);

  void _onSlidePuzzleInitialized(
    SlidePuzzleInitialized event,
    Emitter<SlidePuzzleState> emit,
  ) {
    var data = generateSolvableProductsList(5);
    cats = data.keys.first;
    productsList = data.values.first;

    int numberOfCorrectProducts = 0;

    for (var cat in cats) {
      var servedMeals = _checkSolution(cat);
      cat.servedMeals = servedMeals;

      numberOfCorrectProducts = numberOfCorrectProducts + servedMeals.length;

    }

    Puzzle puzzle = Puzzle(products: productsList);

    emit(
      SlidePuzzleState(
        puzzle: puzzle,
        numberOfCorrectTiles: numberOfCorrectProducts,
        puzzleStatus: PuzzleStatus.incomplete,
        cats: cats,
      ),
    );
  }

  void _onProductTapped(ProductTapped event, Emitter<SlidePuzzleState> emit) {
    final tappedProduct = event.product;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      if (state.puzzle.isTileMovable(tappedProduct)) {
        Product whiteSpaceProduct = state.puzzle.getWhitespaceTile();
        BoardPosition whiteSpaceProductPosition = whiteSpaceProduct.position;
        BoardPosition tappedProductPosition = tappedProduct.position;
        Cat whiteSpaceCat = whiteSpaceProduct.cat;
        Cat tappedProductCat = tappedProduct.cat;

        tappedProduct.position = whiteSpaceProductPosition;
        tappedProduct.cat = whiteSpaceCat;
        productsList[whiteSpaceProductPosition.y - 1]
            [whiteSpaceProductPosition.x - 1] = tappedProduct;

        whiteSpaceProduct.position = tappedProductPosition;
        whiteSpaceProduct.cat = tappedProductCat;
        productsList[tappedProductPosition.y - 1][tappedProductPosition.x - 1] =
            whiteSpaceProduct;


        int numberOfCorrectProducts = 0;

        for (var cat in cats) {
          var servedMeals = _checkSolution(cat);
          cat.servedMeals = servedMeals;

          numberOfCorrectProducts =
              numberOfCorrectProducts + servedMeals.length;
        }

        PuzzleStatus puzzleStatus = PuzzleStatus.incomplete;
        if (numberOfCorrectProducts == 8) {
          puzzleStatus = PuzzleStatus.complete;
        }

        puzzle = Puzzle(products: productsList);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle,
              puzzleStatus: puzzleStatus,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfMoves: state.numberOfMoves + 1,
              numberOfCorrectTiles: numberOfCorrectProducts,
              cats: cats,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle,
              puzzleStatus: puzzleStatus,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfMoves: state.numberOfMoves + 1,
              numberOfCorrectTiles: numberOfCorrectProducts,
              cats: cats,
            ),
          );
        }
      } else {
        emit(
          state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
        );
      }
    } else {
      emit(
        state.copyWith(tileMovementStatus: TileMovementStatus.cannotBeMoved),
      );
    }
  }

  List<Meal> _checkSolution(Cat cat) {
    List<BoardPosition> positions = cat.positions;
    List<Meals> catMeals = [];
    List<Meal> servedMeals = [];
    for (var meal in CuisineExt.getMealsByCuisine(cat.cuisine)) {
      catMeals.add(meal);
    }

    for (BoardPosition position in positions) {
      productsList[position.y - 1][position.x - 1].isSelected = false;
    }

    for (BoardPosition position in positions) {
      int x = position.x - 1;
      int y = position.y - 1;

      ///go horizontally
      if (positions.contains(BoardPosition(x: position.x + 2, y: position.y))) {
        Product product1 = productsList[y][x];
        Product product2 = productsList[y][x + 1];
        Product product3 = productsList[y][x + 2];

        Set<Product> products = {product1, product2, product3};

        if (!product1.isSelected &&
            !product2.isSelected &&
            !product3.isSelected) {
          var currIngredients = _createIngredientSet(products);

          for (var entries in Data().mealIngredients.entries) {
            var ingredients = entries.key;

            if (ingredients.difference(currIngredients).isEmpty &&
                catMeals.contains(entries.value.meal)) {
              for (Product product in products) {
                int x = product.position.x - 1;
                int y = product.position.y - 1;

                productsList[y][x].isSelected = true;
              }

              servedMeals.add(Meal(meal: entries.value.meal));
            }
          }
        }
      }

      ///go vertically

      if (positions.contains(BoardPosition(x: position.x, y: position.y + 2))) {
        Product product1 = productsList[y][x];
        Product product2 = productsList[y + 1][x];
        Product product3 = productsList[y + 2][x];

        Set<Product> products = {product1, product2, product3};

        if (!product1.isSelected &&
            !product2.isSelected &&
            !product3.isSelected) {
          var currIngredients = _createIngredientSet(products);

          for (var entries in Data().mealIngredients.entries) {
            var ingredients = entries.key;

            if (ingredients.difference(currIngredients).isEmpty &&
                catMeals.contains(entries.value.meal)) {
              for (Product product in products) {
                int x = product.position.x - 1;
                int y = product.position.y - 1;

                productsList[y][x].isSelected = true;
              }

              servedMeals.add(Meal(meal: entries.value.meal));
            }
          }
        }
      }
    }
    return servedMeals;
  }

  Set<Ingredient> _createIngredientSet(Set<Product> products) {
    Set<Ingredient> ingredients = {};

    for (Product product in products) {
      ingredients.add(product.ingredient);
    }

    return ingredients;
  }

  Map<List<Cat>, List<List<Product>>> generateSolvableProductsList(int size) {
    List<List<Product>> products = [];
    List<Cat> catsReturn = [];
    for (int j = 1; j <= size; j++) {
      var productsList = <Product>[];
      for (int i = 1; i <= size; i++) {
        Product product =
            Data().defaultProduct.copyWith(position: BoardPosition(x: i, y: j));
        productsList.add(product);
      }
      products.add(productsList);
    }

    List<Cat> cats = Data().defaultCatsList();

    ///5 to 5 -> 24 products 3 cats = 8 products -> 3 products 3 products 2 products
    var nums = <int>[10, 9, 6];

    ///decide randomly which cat will have 2 and 3 meals
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

    ///create board
    List<BoardPosition> corners = [
      const BoardPosition(x: 1, y: 1),
      const BoardPosition(x: 1, y: 5),
      const BoardPosition(x: 5, y: 1),
      const BoardPosition(x: 5, y: 5)
    ];

    int cornerIndex = _random.nextInt(corners.length);
    Map<int, List<BoardPosition>> positionsMap =
        _createBoard(corners[cornerIndex].x, corners[cornerIndex].y);

    ///assign meals for each cat from meals list
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

      List<BoardPosition>? positions = positionsMap[count];

      cat.positions = positions!;

      List<Ingredient> ingredients = [];

      for (Meal meal in cat.meals) {
        for (var entry in Data().mealIngredients.entries) {
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
          products[y - 1][x - 1] = Data().defaultProduct.copyWith(
                ingredient: ingredients[index],
                position: BoardPosition(x: x, y: y),
                cat: cat,
              );
          index++;
        }
      }

      catsReturn.add(cat);
    }

    var shuffled = ProductHelper().shuffleProducts(size, products);

    return {catsReturn: shuffled};
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
}
