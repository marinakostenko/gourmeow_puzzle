import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/audio_player/bloc/audio_control_bloc.dart';
import 'package:gourmeow_puzzle/audio_player/widgets/audio_control_widget.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';
import 'package:gourmeow_puzzle/slide_puzzle/bloc/slide_puzzle_bloc.dart';
import 'package:gourmeow_puzzle/slide_puzzle/slide_puzzle_button.dart';
import 'package:gourmeow_puzzle/timer/ticker.dart';
import 'package:gourmeow_puzzle/timer/timer_count_up/bloc/timer_count_up_bloc.dart';
import 'package:gourmeow_puzzle/timer/timer_count_up/timer_count_up.dart';
import 'package:gourmeow_puzzle/widgets/cats_builder_widget.dart';
import 'package:gourmeow_puzzle/widgets/game_over_page.dart';
import 'package:gourmeow_puzzle/widgets/statistics_widget.dart';

class SlidePuzzlePage extends StatefulWidget {
  const SlidePuzzlePage({Key? key}) : super(key: key);

  @override
  _SlidePuzzlePageState createState() => _SlidePuzzlePageState();
}

class _SlidePuzzlePageState extends State<SlidePuzzlePage> {
  dynamic size;
  dynamic ratio;
  dynamic boardHeightWidth;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    ratio = size.width / size.height;
    boardHeightWidth = ratio < 1 ? size.width * 0.8 : size.height * 0.8;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: const [
          AudioControl(),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 530),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => SlidePuzzleBloc()
                ..add(
                  const SlidePuzzleInitialized(shufflePuzzle: true, size: 5),
                ),
            ),
            BlocProvider(create: (context) => AudioControlBloc()),
            BlocProvider(
              create: (context) => TimerCountUpBloc(ticker: const Ticker())..add(const TimerCountUpStarted()),
            ),
          ],
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 100,
              ),
              child: LayoutBuilder(builder: (context, constraints) {
                return buildPuzzle(context);
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPuzzle(BuildContext context) {
    var puzzle = context.select((SlidePuzzleBloc bloc) => bloc.state.puzzle);
    var count =
        context.select((SlidePuzzleBloc bloc) => bloc.state.numberOfMoves);
    var numberOfTilesLeft = context
        .select((SlidePuzzleBloc bloc) => bloc.state.numberOfCorrectTiles);

    debugPrint("Number of moves count $count");
    debugPrint("Number of tiles left $numberOfTilesLeft");

    var productTable = puzzle.products;
    var products = <Widget>[];

    for (List<Product> productsList in productTable) {
      for (Product product in productsList) {
        products.add(SlidePuzzleButton(
            product: product,
            itemSize: boardHeightWidth / 5,
            state: context.select((SlidePuzzleBloc bloc) => bloc.state)));
      }
    }

    final puzzleSize = puzzle.getDimension();
    if (puzzleSize == 0) return const CircularProgressIndicator();

    if (ratio < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Statistics(moves: count, dishes: numberOfTilesLeft,),
          //_statistics(count, numberOfTilesLeft),
          _boardBuilder(context, 5, products),
          _catsBuilder(context),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Statistics(moves: count, dishes: numberOfTilesLeft,),
          //_statistics(count, numberOfTilesLeft),
          _boardBuilder(context, 5, products),
          _catsBuilder(context),
        ],
      );
    }
  }

  Widget _boardBuilder(
      BuildContext context, int boardSize, List<Widget> products) {
    double boardHeightWidth = ratio < 1 ? size.width * 0.8 : size.width * 0.35;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: boardHeightWidth * 0.1),
      height: boardHeightWidth,
      width: boardHeightWidth,
      child: Column(
        children: [
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: boardSize,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: boardHeightWidth * 0.01,
            crossAxisSpacing: boardHeightWidth * 0.01,
            children: products,
          ),
        ],
      ),
    );
  }

  Widget _catsBuilder(BuildContext context) {
    return BlocConsumer<SlidePuzzleBloc, SlidePuzzleState>(
      listener: (context, state) {
        if (state.puzzleStatus == PuzzleStatus.complete) {
          context.read<TimerCountUpBloc>().add(const TimerCountUpStopped());

          Navigator.of(context, rootNavigator: true).pushReplacement(
            PageRouteBuilder(
              transitionDuration: Duration(seconds: 2),
              pageBuilder: (_, __, ___) =>
                  GameOverPage(moves: 1, dishes: 1, cats: state.cats),
            ),
          );
        }
      },
      builder: (context, state) {
        return Hero(
          tag: 'cats-hero',
          child: CatsBuilder(
            cats: state.cats,
            displayMenu: true,
          ),
        );
      },
    );
  }

  Widget _statistics(int moves, int dishes) {
    double fontSize = ratio < 1 ? size.height * 0.03 : size.width * 0.015;
    double sectionWidth = ratio < 1 ? size.width : size.width * 0.25;

    return Container(
      alignment: Alignment.center,
      width: sectionWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TimerCountUp(iconSize: fontSize,),
          SizedBox(
            height: fontSize * 0.8,
          ),
          Container(
            child: Text(
              "Number of moves $moves",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: fontSize,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          SizedBox(
            height: fontSize * 0.8,
          ),
          Container(
            child: Text(
              "Prepared dishes $dishes / 8",
              style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: fontSize,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ),
          const Recipes(
            cuisine: Cuisine.none,
            text: Text("Menu"),
          ),
        ],
      ),
    );
  }
}
