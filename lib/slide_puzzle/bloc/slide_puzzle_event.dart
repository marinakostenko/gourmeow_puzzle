part of 'slide_puzzle_bloc.dart';

abstract class SlidePuzzleEvent extends Equatable {
  const SlidePuzzleEvent();

  @override
  List<Object> get props => [];
}

class SlidePuzzleInitialized extends SlidePuzzleEvent {
  const SlidePuzzleInitialized({required this.shufflePuzzle, required this.size});

  final bool shufflePuzzle;
  final int size;

  @override
  List<Object> get props => [shufflePuzzle, size];
}

class ProductTapped extends SlidePuzzleEvent {
  const ProductTapped(this.product);

  final Product product;

  @override
  List<Object> get props => [product];
}

class SlidePuzzleReset extends SlidePuzzleEvent {
  const SlidePuzzleReset();
}