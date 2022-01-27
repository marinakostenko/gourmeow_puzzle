part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  final Puzzle puzzle;
  final int count;

  const PuzzleState({this.puzzle = const Puzzle(products: []), this.count = 0,});

  PuzzleState copyWith({
    Puzzle? puzzle,
    int? count,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      count: count ?? this.count,
    );
  }

  @override
  List<Object> get props => [puzzle, count];
}
