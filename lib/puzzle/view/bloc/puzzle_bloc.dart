import 'dart:async';
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
  PuzzleBloc() : super(PuzzleInitial());

  var size;
  var puzzle;
  var productsList;
  var cats;

  @override
  Stream<PuzzleState> mapEventToState(
      PuzzleEvent event,
      ) async* {

    if(event is PuzzleInitialized) {
      productsList = Utils().defaultProductsList(size);
      cats = Utils().defaultCatsList();
      puzzle = Puzzle(productsList);

      puzzle = _setCatWishesPositions(puzzle, cats);

      yield(PuzzleSuccessfullyCreated(puzzle));
    }
  }

  Puzzle _setCatWishesPositions(Puzzle puzzle, List<Cat> cats) {
    int count = 0;
    //TODO add random dishes to selected cats

    final _random = Random();

    while(count < cats.length) {
      while(true) {
        var product = puzzle.products[_random.nextInt(puzzle.products.length)];
        if(product.cat.color == Colors.white) {
          product.cat = cats.elementAt(count);
          break;
        }
      }

      count++;
    }

    return puzzle;
  }
}
