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
class ProductDragged extends PuzzleEvent {
  final Product product;

  const ProductDragged(this.product);

  @override
  List<Object> get props => [product];
}

class ProductDropped extends PuzzleEvent {
  final Product dragProduct;

  final Product dropProduct;

  const ProductDropped(this.dragProduct, this.dropProduct);

  @override
  List<Object> get props => [dragProduct, dropProduct];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();

}