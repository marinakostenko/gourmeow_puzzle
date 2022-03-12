import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/helpers/audio_players.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/slide_puzzle/slide_puzzle_page.dart';
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
    return Material(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minHeight: 100,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10.0),
                child: const Text(
                  "Game over You made it!",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 48, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(20),
                  ).copyWith(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.white.withOpacity(0.8)),
                    foregroundColor: MaterialStateProperty.all(Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const SlidePuzzlePage(),
                      ),
                    );
                  },
                  child: const Text(
                    "Restart",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.indigo),
                  ),
                ),
              ),
              Hero(
                tag: 'cats-hero',
                child: CatsBuilder(
                  cats: widget.cats,
                  displayMenu: false,
                ),
              ),
              Statistics(
                moves: widget.moves,
                dishes: widget.dishes,
                completed: true,
                seconds: widget.seconds,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
