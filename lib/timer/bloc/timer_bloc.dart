import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../ticker.dart';

part 'timer_event.dart';

part 'timer_state.dart';

class TimerBloc extends Bloc<TimerEvent, TimerState> {
  final Ticker _ticker;
  final int _duration = 30;

  StreamSubscription<int>? _tickerSubscription;

  TimerBloc({required Ticker ticker})
      : _ticker = ticker,
        super(const TimerState()) {
    on<TimerEvent>((event, emit) {
      on<TimerStarted>(_onTimerStarted);
      on<TimerTicked>(_onTimerTicked);
      on<TimerStopped>(_onTimerStopped);
      on<TimerReset>(_onTimerReset);
    });
  }

  @override
  Future<void> close() {
    _tickerSubscription?.cancel();
    return super.close();
  }

  void _onTimerStarted(TimerStarted event, Emitter<TimerState> emit) {
    debugPrint("Timer started");
    _tickerSubscription?.cancel();
    _tickerSubscription = _ticker
        .tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
    emit(state.copyWith(isRunning: true));
  }

  void _onTimerTicked(TimerTicked event, Emitter<TimerState> emit) {
    emit(event.duration > 0
        ? state.copyWith(isRunning: true, duration: event.duration)
        : state.copyWith(isRunning: false, duration: 0));
  }

  void _onTimerStopped(TimerStopped event, Emitter<TimerState> emit) {
    _tickerSubscription?.pause();
    emit(state.copyWith(isRunning: false));
  }

  void _onTimerReset(TimerReset event, Emitter<TimerState> emit) {
    _tickerSubscription?.cancel();
    emit(state.copyWith(duration: _duration));
  }
}
