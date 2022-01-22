import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/models/puzzle.dart';
import 'package:gourmeow_puzzle/puzzle/utils/utils.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(PuzzleInitial()) {
    on<PuzzleInitialized>((event, emit) => _onPuzzleInitialized(event, emit));
  }

  void _onPuzzleInitialized(
    PuzzleInitialized event,
    Emitter<PuzzleState> emit,
  ) {
    var productsList = Utils().defaultProductsList(event.size);

    var cats = Utils().defaultCatsList();
    var puzzle = Puzzle(productsList);

    puzzle = _setCatWishesPositions(puzzle, cats);

    emit(
      PuzzleSuccessfullyCreated(
        puzzle,
      ),
    );
  }

  Puzzle _setCatWishesPositions(Puzzle puzzle, List<Cat> cats) {
    //TODO add random dishes to selected cats

    final _random = Random();

    for(Cat cat in cats) {
      while (true) {
        var product = puzzle.products.elementAt(_random.nextInt(puzzle.products.length));

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
