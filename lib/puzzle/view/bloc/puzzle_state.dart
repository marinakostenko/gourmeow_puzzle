part of 'puzzle_bloc.dart';

class PuzzleState extends Equatable {
  final Puzzle puzzle;

  const PuzzleState({this.puzzle = const Puzzle(products: [])});

  PuzzleState copyWith({
    Puzzle? puzzle,
  }) {
    return PuzzleState(
      puzzle: puzzle ?? this.puzzle,
    );
  }

  @override
  List<Object> get props => [puzzle];
}
