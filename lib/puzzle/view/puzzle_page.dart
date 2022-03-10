import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/bloc/puzzle_bloc.dart';
import 'package:gourmeow_puzzle/recipes/recipes_widget.dart';
import 'package:gourmeow_puzzle/timer/ticker.dart';
import 'package:gourmeow_puzzle/timer/timer_count_down/bloc/timer_bloc.dart';
import 'package:gourmeow_puzzle/timer/timer_count_down/timer_count_down.dart';
import 'package:gourmeow_puzzle/widgets/cats_builder_widget.dart';

import 'drag_drop_widget.dart';

class PuzzlePage extends StatefulWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  _PuzzlePageState createState() => _PuzzlePageState();
}

class _PuzzlePageState extends State<PuzzlePage> {
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
        backgroundColor: Colors.transparent,
        actions: const [
          Recipes(
            cuisine: Cuisine.none,
          ),
        ],
      ),
      backgroundColor: Colors.black,
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 530),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PuzzleBloc()
                ..add(
                  const PuzzleInitialized(true, 6),
                ),
            ),
            BlocProvider(
              create: (context) => TimerBloc(ticker: const Ticker()),
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
    final state = context.select((PuzzleBloc bloc) => bloc.state.count);
    debugPrint("state count $state");

    var puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    var matchingProducts =
        context.select((PuzzleBloc bloc) => bloc.state.matchingProducts);
    var emptyProducts =
        context.select((PuzzleBloc bloc) => bloc.state.emptyProducts);
    var emptyProductsMoved =
        context.select((PuzzleBloc bloc) => bloc.state.emptyProductsMoved);

    var cats = context.select((PuzzleBloc bloc) => bloc.state.cats);
    var updateCats = context.select((PuzzleBloc bloc) => bloc.state.updateCats);

    var timerFinished = context.select((TimerBloc bloc) => bloc.timerFinished);

    var gameFinished =
        context.select((PuzzleBloc bloc) => bloc.state.gameFinished);

    if (gameFinished) {
      return _gameFinishOverlay(context);
    }

    debugPrint("Timer finished " + timerFinished.toString());

    if (timerFinished) {
      context.read<PuzzleBloc>().add(TimeEnded(cats));
      BlocProvider.of<TimerBloc>(context).timerFinished = false;
    }

    var productTable = puzzle.products;
    var products = <Widget>[];

    for (List<Product> productsList in productTable) {
      for (Product product in productsList) {
        products.add(itemBuilder(context, product));
      }
    }

    if (matchingProducts.isNotEmpty) {
      context.read<PuzzleBloc>().add(ProductSelected(matchingProducts));
    }

    if (emptyProducts.isNotEmpty && !emptyProductsMoved) {
      context.read<PuzzleBloc>().add(MoveEmptyProducts(emptyProducts));
    }

    if (emptyProducts.isNotEmpty && emptyProductsMoved) {
      context
          .read<PuzzleBloc>()
          .add(FillEmptyProducts(emptyProducts, updateCats, cats));
    }

    if (updateCats) {
      context.read<TimerBloc>().add(const TimerReset());
    }

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    if (ratio < 1) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _boardBuilder(context, 6, products),
          CatsBuilder(
            cats: cats,
            displayMenu: true,
          ),
          timeBuilder(context, cats),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _boardBuilder(context, 6, products),
          Column(
            children: [
              CatsBuilder(
                cats: cats,
                displayMenu: true,
              ),
              timeBuilder(context, cats),
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

  Widget itemBuilder(BuildContext context, Product product) {
    void _onDragStart(Product product) async {
      context.read<PuzzleBloc>().add(ProductDragged(product));
    }

    void _onDragEnd(Product product) {}

    void _onDragAccept(Product dropProduct, Product dragProduct) {
      debugPrint(
          "drag accepted called - drag ${dragProduct.ingredient.ingredient.name} - drop ${dropProduct.ingredient.ingredient.name}");
      context.read<PuzzleBloc>().add(ProductDropped(dragProduct, dropProduct));
    }

    return DragDrop(
      product: product,
      onDragStart: _onDragStart,
      onDragEnd: _onDragEnd,
      onDragAccept: _onDragAccept,
    );
  }

  Widget timeBuilder(BuildContext context, List<Cat> cats) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 100,
          height: 100,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(8.0),
          child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Colors.indigo,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            onPressed: () => context.read<PuzzleBloc>().add(TimeEnded(cats)),
            child: const Text(
              "READY",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
        const TimerCountdown(),
      ],
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
              "Game over",
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
                context
                    .read<PuzzleBloc>()
                    .add(const PuzzleInitialized(true, 6));
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
