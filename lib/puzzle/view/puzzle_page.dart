import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gourmeow_puzzle/puzzle/models/cat.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';
import 'package:gourmeow_puzzle/timer/bloc/timer_bloc.dart';
import 'package:gourmeow_puzzle/timer/ticker.dart';
import 'package:gourmeow_puzzle/timer/timer_countdown.dart';

import 'bloc/puzzle_bloc.dart';
import 'drag_drop_widget.dart';

class PuzzlePage extends StatelessWidget {
  const PuzzlePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PuzzleView();
  }
}

class PuzzleView extends StatelessWidget {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 530),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PuzzleBloc()
                ..add(
                  const PuzzleInitialized(true, 5),
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

    var resetTimer = context.select((PuzzleBloc bloc) => bloc.state.resetTimer);

    var timerFinished = context.select((TimerBloc bloc) => bloc.timerFinished);

    if(resetTimer) {
      context.read<TimerBloc>().add(TimerReset());
    }

    debugPrint("Timer finished " + timerFinished.toString());
    if(timerFinished) {
      context.read<PuzzleBloc>().add(TimeEnded(cats));
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

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        boardBuilder(context, 5, products),
        catBuilder(context, cats),
      ],
    );
  }

  Widget boardBuilder(BuildContext context, int size, List<Widget> products) {
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

  Widget catBuilder(BuildContext context, List<Cat> cats) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          width: 200,
          child: ListView(
            // scrollDirection: Axis.horizontal,
            children: List.generate(cats.length, (index) {
              Cat cat = cats.elementAt(index);

              return Container(
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  color: cat.color,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  cat.meal.meal.name + "\n" + cat.livesCount.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              );
            }),
          ),
        ),
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
}
