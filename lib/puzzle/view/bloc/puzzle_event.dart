part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized(this.newGame);

  final bool newGame;

  @override
  List<Object> get props => [newGame];
}

class ProductTapped extends PuzzleEvent {
  const ProductTapped(this.product);

  final Product product;

  @override
  List<Object> get props => [product];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}