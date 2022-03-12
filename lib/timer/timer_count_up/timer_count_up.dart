import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/config/main_theme_animation_duration.dart';
import 'package:gourmeow_puzzle/timer/timer_count_up/bloc/timer_count_up_bloc.dart';
import 'package:provider/src/provider.dart';

class TimerCountUp extends StatelessWidget {
  const TimerCountUp({
    Key? key,
    required this.iconSize,
    required this.completed,
    required this.seconds,

  }) : super(key: key);

  final double iconSize;
  final bool completed;
  final int seconds;

  @override
  Widget build(BuildContext context) {
    final secondsElapsed =
        context.select((TimerCountUpBloc bloc) => bloc.state.secondsElapsed);

    dynamic timeElapsed = Duration(seconds: secondsElapsed);

    if (completed) {
      context.read<TimerCountUpBloc>().add(const TimerCountUpStopped());
      timeElapsed = Duration(seconds: seconds);
    }

    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedDefaultTextStyle(
            style: TextStyle(color: Colors.white, fontSize: iconSize),
            duration: PuzzleThemeAnimationDuration.textStyle,
            child: Text(
              _formatDuration(timeElapsed),
              key: ValueKey(secondsElapsed),
            ),
          ),
          const Icon(
            Icons.timer,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
  }
}
