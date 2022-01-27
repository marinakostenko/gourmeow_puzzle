import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/models/puzzle.dart';
import 'package:gourmeow_puzzle/puzzle/utils/utils.dart';

part 'puzzle_event.dart';

part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(const PuzzleState()) {
    on<PuzzleInitialized>(_onPuzzleInitialized);
    on<ProductSwiped>(_onProductSwiped);
    on<ProductDragged>(_onProductDragged);
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

    debugPrint(
        "${productsList[yProduct][xProduct - 1].ingredient.ingredient.name}");
    debugPrint("${productsList[yProduct][xProduct - 1].draggable}");

    debugPrint("drag count $count");
    puzzle = Puzzle(products: productsList);

    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
      ),
    );
  }

  void _onProductSwiped(ProductSwiped event, Emitter<PuzzleState> emit) {
    int count = state.count;

    debugPrint(
        "Product to swipe ${event.dragProduct.ingredient.ingredient.name}");

    int yProduct = event.dragProduct.position.y;
    int xProduct = event.dragProduct.position.x;

    if (xProduct > 0) {
      //left
      productsList[yProduct][xProduct - 1].draggable = Drag.drag;
    }

    if (xProduct < productsList.length - 1) {
      //right
      productsList[yProduct][xProduct + 1].draggable = Drag.drag;
    }

    if (yProduct > 0) {
      //bottom
      productsList[yProduct - 1][xProduct].draggable = Drag.drag;
    }

    if (yProduct < productsList.length - 1) {
      //top
      productsList[yProduct + 1][xProduct].draggable = Drag.drag;
    }

    productsList[event.dropProduct.position.y - 1]
        [event.dropProduct.position.x - 1] = event.dragProduct;
    productsList[yProduct - 1][xProduct - 1] = event.dropProduct;

    puzzle = Puzzle(products: productsList);

    debugPrint("count $count");
    count = count + 1;
    emit(
      state.copyWith(
        puzzle: puzzle,
        count: count,
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
          product.isSelected = true;
          break;
        }
      }
    }

    return puzzle;
  }
}
