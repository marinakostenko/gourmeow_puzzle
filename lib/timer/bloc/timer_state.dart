part of 'timer_bloc.dart';

class TimerState extends Equatable {
  const TimerState({
    this.isRunning = false,
    this.duration = 30,
  });

  final bool isRunning;
  final int duration;

  @override
  List<Object> get props => [isRunning, duration];

  TimerState copyWith({
    bool? isRunning,
    int? duration,
  }) {
    return TimerState(
      isRunning: isRunning ?? this.isRunning,
      duration: duration ?? this.duration,
    );
  }
}
