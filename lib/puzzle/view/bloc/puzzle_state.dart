part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  final Puzzle puzzle;
  final int count;
  final int dragCount;

  const PuzzleState(
      {this.puzzle = const Puzzle(products: []),
      this.count = 0,
      this.dragCount = 0});

  PuzzleState copyWith({Puzzle? puzzle, int? count, int? dragCount}) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
      count: count ?? this.count,
      dragCount: dragCount ?? this.dragCount,
    );
  }

  @override
  List<Object> get props => [puzzle, count, dragCount];
}
