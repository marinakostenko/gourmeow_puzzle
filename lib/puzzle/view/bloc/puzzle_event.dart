part of 'puzzle_bloc.dart';

abstract class PuzzleEvent extends Equatable {
  const PuzzleEvent();

  @override
  List<Object> get props => [];
}

class PuzzleInitialized extends PuzzleEvent {
  const PuzzleInitialized(this.newGame, this.size);

  final int size;
  final bool newGame;

  @override
  List<Object> get props => [newGame];
}

class ProductSwiped extends PuzzleEvent {
  final Product product;

  final BoardPosition swipedPosition;

  const ProductSwiped(this.product, this.swipedPosition);

  @override
  List<Object> get props => [product, swipedPosition];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();

}