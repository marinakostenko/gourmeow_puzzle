import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/helpers/audio_players.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/slide_puzzle/slide_puzzle_page.dart';
import 'package:gourmeow_puzzle/widgets/share_buttons.dart';
import 'package:gourmeow_puzzle/widgets/statistics_widget.dart';
import 'package:just_audio/just_audio.dart';

import 'cats_builder_widget.dart';

class GameOverPage extends StatefulWidget {
  final int moves;
  final int dishes;
  final List<Cat> cats;
  final int seconds;

  final AudioPlayerFactory _audioPlayerFactory;

  const GameOverPage({
    Key? key,
    AudioPlayerFactory? audioPlayer,
    required this.moves,
    required this.dishes,
    required this.cats,
    required this.seconds,
  })  : _audioPlayerFactory = audioPlayer ?? getAudioPlayer,
        super(key: key);

  @override
  _GameOverPageState createState() => _GameOverPageState();
}

class _GameOverPageState extends State<GameOverPage> {
  late final AudioPlayer _successAudioPlayer;

  @override
  void initState() {
    super.initState();

    _successAudioPlayer = widget._audioPlayerFactory()
      ..setAsset('assets/audio/success.mp3');
    unawaited(_successAudioPlayer.play());
  }

  @override
  Widget build(BuildContext context) {
    String scoreToShare =
        "Puzzle completed with only ${widget.moves} moves in ${_formatDuration(Duration(seconds: widget.seconds))}";

    return Material(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  "Well done! Your guests can eat now!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              Statistics(
                moves: widget.moves,
                dishes: widget.dishes,
                completed: true,
                seconds: widget.seconds,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FacebookButton(score: scoreToShare),
                  TwitterButton(
                    score: scoreToShare,
                  ),
                ],
              ),
              Hero(
                tag: 'cats-hero',
                child: CatsBuilder(
                  cats: widget.cats,
                  displayMenu: false,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20),
                ).copyWith(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => const SlidePuzzlePage(),
                    ),
                  );
                },
                child: Text(
                  "Restart",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ],
          ),
        ),
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
