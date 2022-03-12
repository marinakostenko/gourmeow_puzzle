
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:gourmeow_puzzle/data/data.dart';
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
    var data = Data().generateSolvableProductsList(5);
    cats = data.keys.first;
    productsList = data.values.first;

    int numberOfCorrectProducts = 0;

    for (var cat in cats) {
      var servedMeals = _checkSolution(cat);
      cat.servedMeals = servedMeals;

      numberOfCorrectProducts = numberOfCorrectProducts + servedMeals.length;

      debugPrint(servedMeals.map((set) => set.meal.name).toString());
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
    debugPrint("Product tapped");
    final tappedProduct = event.product;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      debugPrint(
          "Tile is movable ${state.puzzle.isTileMovable(tappedProduct)}");
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

        debugPrint(
            "${productsList[whiteSpaceProductPosition.y - 1][whiteSpaceProductPosition.x - 1].ingredient} and "
            "${productsList[tappedProductPosition.y - 1][tappedProductPosition.x - 1].ingredient}");

        int numberOfCorrectProducts = 0;

        for (var cat in cats) {
          var servedMeals = _checkSolution(cat);
          cat.servedMeals = servedMeals;

          numberOfCorrectProducts =
              numberOfCorrectProducts + servedMeals.length;

          debugPrint(servedMeals.map((set) => set.meal.name).toString());
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
}
