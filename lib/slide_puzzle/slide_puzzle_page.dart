import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';
import 'package:gourmeow_puzzle/slide_puzzle/bloc/slide_puzzle_bloc.dart';
import 'package:gourmeow_puzzle/widgets/cats_builder_widget.dart';
import 'package:gourmeow_puzzle/widgets/product_builder_widget.dart';

class SlidePuzzlePage extends StatelessWidget {
  const SlidePuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SlidePuzzleView();
  }
}

class SlidePuzzleView extends StatelessWidget {
  const SlidePuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: const [
          Recipes(isMobile: false),
        ],
      ),
      backgroundColor: Colors.black,
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
    var numberOfTilesLeft =
        context.select((SlidePuzzleBloc bloc) => bloc.state.numberOfCorrectTiles);
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

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

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

  Widget _boardBuilder(BuildContext context, int size, List<Widget> products) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.height / 1.2,
      child: Column(
        children: [
          const Gap(10),
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: size,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: products,
          ),
          const Gap(
            10,
          ),
        ],
      ),
    );
  }

  Widget _statistics(int moves, int dishes) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          child: Text(
            "Number of moves $moves",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        Container(
          child: Text(
            "Number of prepared dishes $dishes",
            style: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _itemBuilder(BuildContext context, Product product) {
    return TextButton(
      onPressed: () {
        context.read<SlidePuzzleBloc>().add(ProductTapped(product));
      },
      child: ProductBuilder(
        product: product,
        size: Size(100, 100),
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
