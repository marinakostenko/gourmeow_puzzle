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
    var count = context.select((SlidePuzzleBloc bloc) => bloc.state.numberOfMoves);
    debugPrint("Numer of moves count $count");

    var productTable = puzzle.products;
    var products = <Widget>[];

    for (List<Product> productsList in productTable) {
      for (Product product in productsList) {
        products.add(itemBuilder(context, product));
      }
    }

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        boardBuilder(context, 5, products),
      ],
    );
  }

  Widget boardBuilder(BuildContext context, int size, List<Widget> products) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.width,
      width: MediaQuery.of(context).size.width * 0.8,
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
    AssetImage image = product.ingredient.ingredient.ingredientImage;

    Color backgroundColor = (product.cat.color != Colors.white)
        ? product.cat.color
        : Colors.white;
    Color borderColor = (product.isSelected) ? Colors.yellow : Colors.transparent;

    if(product.ingredient.ingredient == Ingredients.none) {
      backgroundColor = (product.cat.color != Colors.white)
          ? product.cat.color
          : Colors.transparent;
      borderColor = Colors.transparent;
    }

    return TextButton(
      onPressed: () {
        context.read<SlidePuzzleBloc>().add(ProductTapped(product));
      },
      child: Container(
        margin: EdgeInsets.all(10),
        alignment: Alignment.center,
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: image,
            alignment: Alignment.center,
            repeat: ImageRepeat.noRepeat,
          ),
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2, color: borderColor),
        ),
      ),

    );
  }
}
