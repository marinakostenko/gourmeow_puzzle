part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  final Puzzle puzzle;
  final int count;
  final List<Set<Product>> matchingProducts;
  final Set<Product> emptyProducts;
  final bool emptyProductsMoved;

  const PuzzleState({
    this.puzzle = const Puzzle(products: []),
    this.count = 0,
    this.matchingProducts = const [],
    this.emptyProducts = const <Product>{},
    this.emptyProductsMoved = false,
  });

  PuzzleState copyWith(
      {Puzzle? puzzle,
      int? count,
      List<Set<Product>>? matchingProducts,
      Meal? meal,
      Set<Product>? emptyProducts,
      bool? emptyProductsMoved}) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      count: count ?? this.count,
      matchingProducts: matchingProducts ?? this.matchingProducts,
      emptyProducts: emptyProducts ?? this.emptyProducts,
      emptyProductsMoved: emptyProductsMoved ?? this.emptyProductsMoved,
    );
  }

  @override
  List<Object> get props => [puzzle, count, matchingProducts, emptyProducts, emptyProductsMoved];
}
