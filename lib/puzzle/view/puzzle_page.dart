import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/models/puzzle.dart';

import 'bloc/puzzle_bloc.dart';

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
        child: BlocProvider<PuzzleBloc>(
          create: (context) {
            return PuzzleBloc()
              ..add(
                const PuzzleInitialized(true, 5),
              );
          },
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 100,
              ),
              child: buildPuzzle(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPuzzle() {
    return BlocBuilder<PuzzleBloc, PuzzleState>(
        builder: (BuildContext context, PuzzleState state) {
      log("mystate ${state.toString()}");
      Puzzle puzzle;
      if (state is PuzzleInitial) {
        return const CircularProgressIndicator();
      }

      if (state is PuzzleSuccessfullyCreated) {
        puzzle = state.puzzle;

        var productTable = puzzle.products;
        var products = <Widget>[];

        for (List<Product> productsList in productTable) {
          for (Product product in productsList) {
            products.add(productBuilder(product, state));
          }
        }

        return boardBuilder(
          5,
          products,
          state,
        );
      }

      return Container();
    });
  }

  Widget boardBuilder(int size, List<Widget> products, PuzzleState state) {
    return Padding(
      padding: const EdgeInsets.all(100),
      child: Column(
        children: [
          const Gap(10),
          GridView.count(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            crossAxisCount: size,
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

  Widget productBuilder(Product product, PuzzleState state) {
    return TextButton(
      style: TextButton.styleFrom(
        fixedSize: const Size.square(20),
      ).copyWith(
        //  fixedSize: MaterialStateProperty.all(const Size.square(20)),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) {
            if (product.cat.color != Colors.white) {
              return product.cat.color;
            } else {
              return Colors.black12;
            }
          },
        ),
      ),
      onPressed: () => {},
      child: Text(
        product.ingredient.ingredient.name,
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
