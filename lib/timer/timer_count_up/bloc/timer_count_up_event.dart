part of 'timer_count_up_bloc.dart';

abstract class TimerCountUpEvent extends Equatable {
  const TimerCountUpEvent();

  @override
  List<Object> get props => [];
}

class TimerCountUpStarted extends TimerCountUpEvent {
  const TimerCountUpStarted();
}

class TimerCountUpTicked extends TimerCountUpEvent {
  const TimerCountUpTicked(this.secondsElapsed);

  final int secondsElapsed;

  @override
  List<Object> get props => [secondsElapsed];
}

class TimerCountUpStopped extends TimerCountUpEvent {
  const TimerCountUpStopped();
}

class TimerCountUpReset extends TimerCountUpEvent {
  const TimerCountUpReset();
}