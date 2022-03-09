part of 'slide_puzzle_bloc.dart';

enum PuzzleStatus { incomplete, complete }

enum TileMovementStatus { nothingTapped, cannotBeMoved, moved }

class SlidePuzzleState extends Equatable {
  const SlidePuzzleState({
    this.puzzle = const Puzzle(products: []),
    this.puzzleStatus = PuzzleStatus.incomplete,
    this.tileMovementStatus = TileMovementStatus.nothingTapped,
    this.numberOfCorrectTiles = 0,
    this.numberOfMoves = 0,
    this.cats = const <Cat>[],
  });

  final Puzzle puzzle;

  final PuzzleStatus puzzleStatus;

  final TileMovementStatus tileMovementStatus;

  final int numberOfCorrectTiles;

  final int numberOfMoves;

  final List<Cat> cats;

  SlidePuzzleState copyWith({
    Puzzle? puzzle,
    PuzzleStatus? puzzleStatus,
    TileMovementStatus? tileMovementStatus,
    int? numberOfCorrectTiles,
    int? numberOfMoves,
    List<Cat>? cats,
  }) {
    return SlidePuzzleState(
      puzzle: puzzle ?? this.puzzle,
      puzzleStatus: puzzleStatus ?? this.puzzleStatus,
      tileMovementStatus: tileMovementStatus ?? this.tileMovementStatus,
      numberOfCorrectTiles: numberOfCorrectTiles ?? this.numberOfCorrectTiles,
      numberOfMoves: numberOfMoves ?? this.numberOfMoves,
      cats: cats ?? this.cats,
    );
  }

  @override
  List<Object?> get props => [
    puzzle,
    puzzleStatus,
    tileMovementStatus,
    numberOfCorrectTiles,
    numberOfMoves,
    cats,
  ];
}