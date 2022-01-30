import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

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
    debugPrint("state count ${state}");

    var puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);
    var matchingProducts =
        context.select((PuzzleBloc bloc) => bloc.state.matchingProducts);
    var emptyProducts =
        context.select((PuzzleBloc bloc) => bloc.state.emptyProducts);
    var emptyProductsMoved = context.select((PuzzleBloc bloc) => bloc.state.emptyProductsMoved);

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
      context.read<PuzzleBloc>().add(FillEmptyProducts(emptyProducts));
    }

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return boardBuilder(5, products);
  }

  Widget boardBuilder(int size, List<Widget> products) {
    return Padding(
      padding: const EdgeInsets.all(100),
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
}
