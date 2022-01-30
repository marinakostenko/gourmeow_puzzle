part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  final Puzzle puzzle;
  final int count;
  final Set<Product> matchingProducts;
  final Meal meal;
  final Set<Product> emptyProducts;
  final bool emptyProductsMoved;

  const PuzzleState({
    this.puzzle = const Puzzle(products: []),
    this.count = 0,
    this.matchingProducts = const <Product>{},
    this.meal = const Meal(meal: Meals.none),
    this.emptyProducts = const <Product>{},
    this.emptyProductsMoved = false,
  });

  PuzzleState copyWith(
      {Puzzle? puzzle,
      int? count,
      Set<Product>? matchingProducts,
      Meal? meal,
      Set<Product>? emptyProducts,
      bool? emptyProductsMoved}) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      count: count ?? this.count,
      matchingProducts: matchingProducts ?? this.matchingProducts,
      meal: meal ?? this.meal,
      emptyProducts: emptyProducts ?? this.emptyProducts,
      emptyProductsMoved: emptyProductsMoved ?? this.emptyProductsMoved,
    );
  }

  @override
  List<Object> get props => [puzzle, count, matchingProducts, emptyProducts, emptyProductsMoved];
}
