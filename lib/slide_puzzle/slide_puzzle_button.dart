import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/audio_player/widgets/audio_control_listener.dart';
import 'package:gourmeow_puzzle/config/main_theme_animation_duration.dart';
import 'package:gourmeow_puzzle/helpers/audio_players.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/slide_puzzle/bloc/slide_puzzle_bloc.dart';
import 'package:gourmeow_puzzle/widgets/product_builder_widget.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/src/provider.dart';

class SlidePuzzleButton extends StatefulWidget {
  const SlidePuzzleButton({
    Key? key,
    required this.product,
    required this.state,
    required this.itemSize,
    AudioPlayerFactory? audioPlayer,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  final Product product;
  final SlidePuzzleState state;
  final double itemSize;

  final AudioPlayerFactory _audioPlayerFactory;

  @override
  State<SlidePuzzleButton> createState() => SlidePuzzleButtonState();
}

class SlidePuzzleButtonState extends State<SlidePuzzleButton>
    with SingleTickerProviderStateMixin {
  AudioPlayer? _audioPlayer;
  late final Timer _timer;

  late AnimationController _controller;
  late Animation<double> _scale;
  late Animation<Color?> _colorTween;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: PuzzleThemeAnimationDuration.puzzleTileScale,
    );

    _scale = Tween<double>(begin: 1, end: 0.94).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 1, curve: Curves.easeInOut),
      ),
    );

    _colorTween =
        ColorTween(begin: Colors.transparent, end: Colors.yellow.withOpacity(1))
            .animate(_controller);

    _timer = Timer(const Duration(seconds: 1), () {
      _audioPlayer = widget._audioPlayerFactory()
        ..setAsset('audio/tile_move.mp3');
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = widget.state.puzzle.getDimension();

    const movementDuration = Duration(milliseconds: 370);

    return AudioControlListener(
      audioPlayer: _audioPlayer,
      child: AnimatedAlign(
        alignment: FractionalOffset(
          (widget.product.position.x - 1) / (size - 1),
          (widget.product.position.y - 1) / (size - 1),
        ),
        duration: movementDuration,
        curve: Curves.easeInOut,
        child: MouseRegion(
          onEnter: (_) {
            _controller.forward();
          },
          onExit: (_) {
            _controller.reverse();
          },
          child: ScaleTransition(
            scale: _scale,
            child: AnimatedBuilder(
              animation: _colorTween,
              builder: (BuildContext context, Widget? child) => OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(width: 5, color: _colorTween.value!),
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                //padding: EdgeInsets.zero,
                onPressed: () {
                  context
                      .read<SlidePuzzleBloc>()
                      .add(ProductTapped(widget.product));

                  unawaited(_audioPlayer?.replay());
                },
                child: ProductBuilder(
                  product: widget.product,
                  size: Size(widget.itemSize, widget.itemSize),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
