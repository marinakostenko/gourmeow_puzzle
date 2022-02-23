import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';
import 'package:gourmeow_puzzle/slide_puzzle/bloc/slide_puzzle_bloc.dart';
import 'package:gourmeow_puzzle/widgets/cats_builder_widget.dart';
import 'package:gourmeow_puzzle/widgets/product_builder_widget.dart';

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
        backgroundColor: Theme.of(context).colorScheme.primaryVariant,
        actions: const [
          Recipes(
            cuisine: Cuisine.none,
          ),
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
    var cats = context.select((SlidePuzzleBloc bloc) => bloc.cats);
    debugPrint("Number of moves count $count");

    var productTable = puzzle.products;
    var products = <Widget>[];

    var puzzleStatus =
        context.select((SlidePuzzleBloc bloc) => bloc.state.puzzleStatus);

    if (puzzleStatus == PuzzleStatus.complete) {
      return _gameFinishOverlay(context);
    }

    for (List<Product> productsList in productTable) {
      for (Product product in productsList) {
        products.add(_itemBuilder(context, product));
      }
    }

    final puzzleSize = puzzle.getDimension();
    if (puzzleSize == 0) return const CircularProgressIndicator();

    if (ratio < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _statistics(count, numberOfTilesLeft),
          _boardBuilder(context, 5, products),
          CatsBuilder(cats: cats),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _boardBuilder(context, 5, products),
          Column(
            children: [
              CatsBuilder(cats: cats),
              _statistics(count, numberOfTilesLeft),
            ],
          ),
        ],
      );
    }
  }

  Widget _boardBuilder(
      BuildContext context, int boardSize, List<Widget> products) {
    double boardHeightWidth = ratio < 1 ? size.width * 0.8 : size.height * 0.8;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(boardHeightWidth * 0.01),
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

  Widget _statistics(int moves, int dishes) {
    double fontSize = ratio < 1 ? size.height * 0.03 : size.width * 0.015;
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.all(fontSize),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, Product product) {
    double itemSize = boardHeightWidth / 5;
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        context.read<SlidePuzzleBloc>().add(ProductTapped(product));
      },
      child: ProductBuilder(
        product: product,
        size: Size(itemSize, itemSize),
      ),
    );
  }

  Widget _gameFinishOverlay(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.lightBlue.withOpacity(0.8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.withOpacity(0.8),
              borderRadius: BorderRadius.circular(5),
            ),
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
                backgroundColor:
                    MaterialStateProperty.all(Colors.white.withOpacity(0.8)),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: () {
                context.read<SlidePuzzleBloc>().add(
                    const SlidePuzzleInitialized(shufflePuzzle: true, size: 6));
              },
              child: const Text(
                "Restart",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 32, color: Colors.indigo),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
