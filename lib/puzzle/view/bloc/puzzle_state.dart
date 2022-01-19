part of 'puzzle_bloc.dart';

abstract class PuzzleState extends Equatable {
  const PuzzleState();

  @override
  List<Object> get props => [];
}

class PuzzleInitial extends PuzzleState {
}

class PuzzleSuccessfullyCreated extends PuzzleState {
  final Puzzle puzzle;

  const PuzzleSuccessfullyCreated(this.puzzle);

  @override
  List<Object> get props => [puzzle];
}
