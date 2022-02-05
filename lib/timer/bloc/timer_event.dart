part of 'timer_bloc.dart';

abstract class TimerEvent extends Equatable {
  const TimerEvent();

  @override
  List<Object> get props => [];
}

class TimerStarted extends TimerEvent {
  final int duration;

  const TimerStarted({required this.duration});
}

class TimerTicked extends TimerEvent {
  final int duration;

  const TimerTicked({required this.duration});

  @override
  List<Object> get props => [duration];
}

class TimerStopped extends TimerEvent {
  const TimerStopped();
}

class TimerReset extends TimerEvent {
  const TimerReset();
}