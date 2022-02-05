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

class ProductSelected extends PuzzleEvent {
  final List<Set<Product>> products;

  const ProductSelected(this.products);

  @override
  List<Object> get props => [products];
}

class MoveEmptyProducts extends PuzzleEvent {
  final Set<Product> products;

  const MoveEmptyProducts(this.products);

  @override
  List<Object> get props => [products];
}

class FillEmptyProducts extends PuzzleEvent {
  final Set<Product> products;
  final bool updateCats;
  final List<Cat> cats;

  const FillEmptyProducts(this.products, this.updateCats, this.cats);

  @override
  List<Object> get props => [products, updateCats, cats];
}

class TimeEnded extends PuzzleEvent {
  final List<Cat> cats;

  const TimeEnded(this.cats);

  @override
  List<Object> get props => [cats];
}

class TimeReset extends PuzzleEvent {
  final bool reset;

  const TimeReset(this.reset);

  @override
  List<Object> get props => [reset];
}

class PuzzleReset extends PuzzleEvent {
  const PuzzleReset();
}
