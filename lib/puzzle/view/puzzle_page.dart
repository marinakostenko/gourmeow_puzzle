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
        body: BlocProvider<PuzzleBloc>(
          create: (context) {
            return PuzzleBloc()..add(
              PuzzleInitialized(true, 5),
            );
          },
          child: buildPuzzle(context)
      ),
    );
  }

  Widget buildPuzzle(BuildContext context) {
    return BlocBuilder<PuzzleBloc, PuzzleState>(
        builder: (BuildContext context, PuzzleState state) {
          Puzzle puzzle;
          if (state is PuzzleInitial) {
            return const CircularProgressIndicator();
          }

          if (state is PuzzleSuccessfullyCreated) {
            puzzle = state.puzzle;
            return boardBuilder(
              5,
              puzzle.products
                  .map(
                    (product) => productBuilder(
                  product,
                  state,
                ),
              )
                  .toList(),
              state,
            );
          }

          return Container();
        });
  }

  Widget boardBuilder(int size, List<Widget> products, PuzzleState state) {
    return Column(
      children: [
        const Gap(80),
        GridView.count(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: size,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          children: products,
        ),
        const Gap(
          96,
        ),
      ],
    );
  }

  Widget productBuilder(Product product, PuzzleState state) {
    return TextButton(
      style: TextButton.styleFrom(
        primary: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ).copyWith(
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
        product.ingredient.toString(),
      ),
    );
  }
}

