import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:gourmeow_puzzle/data/data.dart';
import 'package:gourmeow_puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/models/puzzle.dart';

part 'slide_puzzle_event.dart';
part 'slide_puzzle_state.dart';

class SlidePuzzleBloc extends Bloc<SlidePuzzleEvent, SlidePuzzleState> {
  SlidePuzzleBloc() : super(const SlidePuzzleState()) {
    on<SlidePuzzleInitialized>(_onSlidePuzzleInitialized);
    on<ProductTapped>(_onProductTapped);
   // on<SlidePuzzleReset>(_onSlidePuzzleReset);
  }

  List<List<Product>> productsList = [];
  List<Cat> cats = [];
  Puzzle puzzle = const Puzzle(products: []);

  void _onSlidePuzzleInitialized(
      SlidePuzzleInitialized event,
      Emitter<SlidePuzzleState> emit,
      ) {

    productsList = Data().generateSolvableProductsList(5);

    Puzzle puzzle = Puzzle(products: productsList);

    emit(
      SlidePuzzleState(
         puzzle: puzzle,
        // numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
      ),
    );
  }

  void _onProductTapped(ProductTapped event, Emitter<SlidePuzzleState> emit) {
    debugPrint("Product tapped");
    final tappedProduct = event.product;
    if (state.puzzleStatus == PuzzleStatus.incomplete) {
      debugPrint("Tile is movable ${state.puzzle.isTileMovable(tappedProduct)}");
      if (state.puzzle.isTileMovable(tappedProduct)) {
        Product whiteSpaceProduct = state.puzzle.getWhitespaceTile();
        BoardPosition whiteSpaceProductPosition = whiteSpaceProduct.position;
        BoardPosition tappedProductPosition = tappedProduct.position;
        Cat whiteSpaceCat = whiteSpaceProduct.cat;
        Cat tappedProductCat = tappedProduct.cat;

        tappedProduct.position = whiteSpaceProductPosition;
        tappedProduct.cat = whiteSpaceCat;
        productsList[whiteSpaceProductPosition.y - 1][whiteSpaceProductPosition.x - 1] = tappedProduct;

        whiteSpaceProduct.position = tappedProductPosition;
        whiteSpaceProduct.cat = tappedProductCat;
        productsList[tappedProductPosition.y - 1][tappedProductPosition.x - 1] = whiteSpaceProduct;

        debugPrint("${productsList[whiteSpaceProductPosition.y - 1][whiteSpaceProductPosition.x - 1].ingredient} and "
            "${productsList[tappedProductPosition.y - 1][tappedProductPosition.x - 1].ingredient}");
        puzzle = Puzzle(products: productsList);
        if (puzzle.isComplete()) {
          emit(
            state.copyWith(
              puzzle: puzzle,
              puzzleStatus: PuzzleStatus.complete,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfMoves: state.numberOfMoves + 1,
            ),
          );
        } else {
          emit(
            state.copyWith(
              puzzle: puzzle,
              tileMovementStatus: TileMovementStatus.moved,
              numberOfMoves: state.numberOfMoves + 1,
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

  // void _onSlidePuzzleReset(SlidePuzzleReset event, Emitter<SlidePuzzleState> emit) {
  //   final puzzle = _generatePuzzle(_size);
  //   emit(
  //     PuzzleState(
  //       puzzle: puzzle.sort(),
  //       numberOfCorrectTiles: puzzle.getNumberOfCorrectTiles(),
  //     ),
  //   );
  // }

  /// Build a randomized, solvable puzzle of the given size.
  // Puzzle _generatePuzzle(int size, {bool shuffle = true}) {
  //   final correctPositions = <Position>[];
  //   final currentPositions = <Position>[];
  //   final whitespacePosition = Position(x: size, y: size);
  //
  //   // Create all possible board positions.
  //   for (var y = 1; y <= size; y++) {
  //     for (var x = 1; x <= size; x++) {
  //       if (x == size && y == size) {
  //         correctPositions.add(whitespacePosition);
  //         currentPositions.add(whitespacePosition);
  //       } else {
  //         final position = Position(x: x, y: y);
  //         correctPositions.add(position);
  //         currentPositions.add(position);
  //       }
  //     }
  //   }
  //
  //   if (shuffle) {
  //     // Randomize only the current tile posistions.
  //     currentPositions.shuffle(random);
  //   }
  //
  //   var tiles = _getTileListFromPositions(
  //     size,
  //     correctPositions,
  //     currentPositions,
  //   );
  //
  //   var puzzle = Puzzle(tiles: tiles);
  //
  //   if (shuffle) {
  //     // Assign the tiles new current positions until the puzzle is solvable and
  //     // zero tiles are in their correct position.
  //     while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
  //       currentPositions.shuffle(random);
  //       tiles = _getTileListFromPositions(
  //         size,
  //         correctPositions,
  //         currentPositions,
  //       );
  //       puzzle = Puzzle(tiles: tiles);
  //     }
  //   }
  //
  //   return puzzle;
  // }

  // /// Build a list of tiles - giving each tile their correct position and a
  // /// current position.
  // List<Tile> _getTileListFromPositions(
  //     int size,
  //     List<Position> correctPositions,
  //     List<Position> currentPositions,
  //     ) {
  //   final whitespacePosition = Position(x: size, y: size);
  //   return [
  //     for (int i = 1; i <= size * size; i++)
  //       if (i == size * size)
  //         Tile(
  //           value: i,
  //           correctPosition: whitespacePosition,
  //           currentPosition: currentPositions[i - 1],
  //           isWhitespace: true,
  //         )
  //       else
  //         Tile(
  //           value: i,
  //           correctPosition: correctPositions[i - 1],
  //           currentPosition: currentPositions[i - 1],
  //         )
  //   ];
  // }
}
