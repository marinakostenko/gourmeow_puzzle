class Ticker {
  const Ticker();
  Stream<int> tickDown({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }

  Stream<int> tickUp() {
    return Stream.periodic(const Duration(seconds: 1), (x) => 1 + x++);
  }
}