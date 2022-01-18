import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

part 'puzzle_event.dart';
part 'puzzle_state.dart';

class PuzzleBloc extends Bloc<PuzzleEvent, PuzzleState> {
  PuzzleBloc() : super(PuzzleInitial());

  @override
  Stream<PuzzleState> mapEventToState(
      PuzzleEvent event,
      ) async* {

    if(event is PuzzleInitialized) {
      
    }
  }
}
