import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/audio_player/bloc/audio_control_bloc.dart';
import 'package:provider/src/provider.dart';

class AudioControl extends StatelessWidget {
  const AudioControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    double iconSize = ratio < 1 ? size.width * 0.05 : size.height * 0.05;

    final audioMuted =
        context.select((AudioControlBloc bloc) => bloc.state.muted);
    final audioAsset = audioMuted
        ? const AssetImage("assets/images/simple_on.png")
        : const AssetImage("assets/images/simple_off.png");

    return Container(
      margin: EdgeInsets.only(right: iconSize),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => context.read<AudioControlBloc>().add(AudioToggled()),
          child: Image(
            image: audioAsset,
            width: iconSize,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
