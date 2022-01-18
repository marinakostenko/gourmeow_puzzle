import 'package:equatable/equatable.dart';

class BoardPosition extends Equatable implements Comparable<BoardPosition>{
  final int x;

  const BoardPosition(this.x, this.y);

  final int y;

  @override
  List<Object?> get props => [x, y];

  @override
  int compareTo(BoardPosition other) {
    if (y < other.y) {
      return -1;
    } else if (y > other.y) {
      return 1;
    } else {
      if (x < other.x) {
        return -1;
      } else if (x > other.x) {
        return 1;
      } else {
        return 0;
      }
    }
  }
}