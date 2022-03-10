import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../ticker.dart';

part 'timer_count_up_event.dart';
part 'timer_count_up_state.dart';

class TimerCountUpBloc extends Bloc<TimerCountUpEvent, TimerCountUpState> {
  TimerCountUpBloc({required Ticker ticker})
      : _ticker = ticker,
  super(const TimerCountUpState()) {
  on<TimerCountUpStarted>(_onTimerCountUpStarted);
  on<TimerCountUpTicked>(_onTimerCountUpTicked);
  on<TimerCountUpReset>(_onTimerCountUpReset);
  on<TimerCountUpStopped>(_onTimerCountUpStopped);
  }

  final Ticker _ticker;

  StreamSubscription<int>? _tickerSubscription;

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onTimerCountUpStarted(TimerCountUpStarted event, Emitter<TimerCountUpState> emit) {
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tickUp()
        .listen((secondsElapsed) => add(TimerCountUpTicked(secondsElapsed)));
    emit(state.copyWith(isRunning: true));
  }

  void _onTimerCountUpTicked(TimerCountUpTicked event, Emitter<TimerCountUpState> emit) {
    emit(state.copyWith(secondsElapsed: event.secondsElapsed));
  }

  void _onTimerCountUpStopped(TimerCountUpStopped event, Emitter<TimerCountUpState> emit) {
    _tickerSubscription?.pause();
    emit(state.copyWith(isRunning: false));
  }


  void _onTimerCountUpReset(TimerCountUpReset event, Emitter<TimerCountUpState> emit) {
    _tickerSubscription?.cancel();
    emit(state.copyWith(secondsElapsed: 0));
  }
}
