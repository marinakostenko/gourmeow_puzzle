import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/puzzle/view/bloc/puzzle_bloc.dart';
import 'package:gourmeow_puzzle/timer/bloc/timer_bloc.dart';

class TimerCountdown extends StatefulWidget {
  const TimerCountdown({Key? key}) : super(key: key);

  @override
  _TimerCountdownState createState() => _TimerCountdownState();
}

class _TimerCountdownState extends State<TimerCountdown> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      buildWhen: (prev, state) => prev.runtimeType != state.runtimeType,
      builder: (context, state) {
        return timer(context);
      },
    );
  }

  Widget timer(BuildContext context) {
    final state = context.select((TimerBloc bloc) => bloc.state);

    debugPrint("timer bloc state $state");

    if (state is TimerInitial) {
      context.read<TimerBloc>().add(TimerStarted(duration: state.duration));
    }

    final duration = context.select((TimerBloc bloc) => bloc.state.duration);
    final minutesStr =
        ((duration / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (duration % 60).floor().toString().padLeft(2, '0');
    return Text(
      '$minutesStr:$secondsStr',
      style: const TextStyle(fontSize: 20, color: Colors.indigo),
    );
  }
}
