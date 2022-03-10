part of 'timer_count_up_bloc.dart';


class TimerCountUpState extends Equatable {
  const TimerCountUpState({
    this.isRunning = false,
    this.secondsElapsed = 0,
  });

  final bool isRunning;
  final int secondsElapsed;

  @override
  List<Object> get props => [isRunning, secondsElapsed];

  TimerCountUpState copyWith({
    bool? isRunning,
    int? secondsElapsed,
  }) {
    return TimerCountUpState(
      isRunning: isRunning ?? this.isRunning,
      secondsElapsed: secondsElapsed ?? this.secondsElapsed,
    );
  }
}