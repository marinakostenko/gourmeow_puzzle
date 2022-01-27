import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:gourmeow_puzzle/puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';
import 'package:gourmeow_puzzle/puzzle/models/puzzle.dart';

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
              child: BlocProvider<PuzzleBloc>(
                lazy: false,
                create: (context) {
                  return PuzzleBloc()
                    ..add(
                      const PuzzleInitialized(true, 5),
                    );
                },
                child: LayoutBuilder(builder: (context, constraints) {
                  return buildPuzzle(context);
                }),
                //child:
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPuzzle(BuildContext context) {
    final state = context.select((PuzzleBloc bloc) => bloc.state);
    debugPrint("${state}");

    var puzzle = context.select((PuzzleBloc bloc) => bloc.state.puzzle);

    debugPrint("${puzzle.products.length}");
    var productTable = puzzle.products;
    var products = <Widget>[];
    

    for (List<Product> productsList in productTable) {
      for (Product product in productsList) {
        products.add(itemBuilder(context, product));
      }
    }

    final size = puzzle.getDimension();
    if (size == 0) return const CircularProgressIndicator();

    return BlocListener<PuzzleBloc, PuzzleState>(
      listener: (BuildContext context, PuzzleState state) {
      },
      child: boardBuilder(5, products),
    );
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
    void _onDragStart(Product product) {
      context.read<PuzzleBloc>().add(ProductDragged(product));
    }

    void _onDragEnd(Product product) {}

    void _onDragAccept(Product dragProduct, Product dropProduct) {
      context
          .read<PuzzleBloc>()
          .add(ProductSwiped(dragProduct, dropProduct.position));
    }
    
    return DragDrop(
      product: product,
      onDragStart: _onDragStart,
      onDragEnd: _onDragEnd,
      onDragAccept: _onDragAccept,
    );
    
  }

// Widget productBuilder(BuildContext context, Product product) {
//
//   //Vertical drag details
//   DragStartDetails? startVerticalDragDetails;
//   DragUpdateDetails? updateVerticalDragDetails;
//
//   //Horizontal drag details
//   DragStartDetails? startHorizontalDragDetails;
//   DragUpdateDetails? updateHorizontalDragDetails;
//
//   return Draggable(
//
//     // onVerticalDragStart: (dragDetails) {
//     //   startVerticalDragDetails = dragDetails;
//     // },
//     // onVerticalDragUpdate: (dragDetails) {
//     //   updateVerticalDragDetails = dragDetails;
//     // },
//     // onVerticalDragEnd: (endDetails) {
//     //   double dx = updateVerticalDragDetails!.globalPosition.dx -
//     //       startVerticalDragDetails!.globalPosition.dx;
//     //   double dy = updateVerticalDragDetails!.globalPosition.dy -
//     //       startVerticalDragDetails!.globalPosition.dy;
//     //
//     //   double? velocity = endDetails.primaryVelocity;
//     //
//     //   if (dx < 0) dx = -dx;
//     //   if (dy < 0) dy = -dy;
//     //   double? positiveVelocity = velocity! < 0 ? -velocity : velocity;
//     //
//     //   debugPrint("$velocity");
//     //
//     //   if (velocity < -50) {
//     //     debugPrint("Swipe up");
//     //
//     //     context.read<PuzzleBloc>().add(ProductSwiped(product,
//     //         BoardPosition(x: product.position.x, y: product.position.y - 1)));
//     //   } else if (velocity > 50) {
//     //     debugPrint("Swipe down");
//     //
//     //     context.read<PuzzleBloc>().add(ProductSwiped(product,
//     //         BoardPosition(x: product.position.x, y: product.position.y + 1)));
//     //   }
//     // },
//     // onHorizontalDragStart: (dragDetails) {
//     //   startHorizontalDragDetails = dragDetails;
//     // },
//     // onHorizontalDragUpdate: (dragDetails) {
//     //   updateHorizontalDragDetails = dragDetails;
//     // },
//     // onHorizontalDragEnd: (endDetails) {
//     //   double dx = updateHorizontalDragDetails!.globalPosition.dx -
//     //       startHorizontalDragDetails!.globalPosition.dx;
//     //   double dy = updateHorizontalDragDetails!.globalPosition.dy -
//     //       startHorizontalDragDetails!.globalPosition.dy;
//     //
//     //   double? velocity = endDetails.primaryVelocity;
//     //
//     //   if (dx < 0) dx = -dx;
//     //   if (dy < 0) dy = -dy;
//     //   double? positiveVelocity = velocity! < 0 ? -velocity : velocity;
//     //
//     //   debugPrint("$velocity");
//     //
//     //   if (velocity < -50) {
//     //     debugPrint("Swipe left");
//     //     context.read<PuzzleBloc>().add(ProductSwiped(product,
//     //         BoardPosition(x: product.position.x - 1, y: product.position.y)));
//     //   } else if (velocity > 50) {
//     //     debugPrint("Swipe right");
//     //     context.read<PuzzleBloc>().add(ProductSwiped(product,
//     //         BoardPosition(x: product.position.x + 1, y: product.position.y)));
//     //   }
//     // },
//     feedback: Container(
//       color: Colors.white,
//     ),
//
//     onDragEnd: (details) {
//       context.read<PuzzleBloc>().add(ProductSwiped(product,
//           BoardPosition(x: product.position.x, y: product.position.y - 1)));
//     },
//     childWhenDragging: Container(),
//     child: TextButton(
//       style: TextButton.styleFrom(
//         fixedSize: const Size.square(20),
//       ).copyWith(
//         //  fixedSize: MaterialStateProperty.all(const Size.square(20)),
//         foregroundColor: MaterialStateProperty.all(Colors.white),
//         backgroundColor: MaterialStateProperty.resolveWith<Color?>(
//           (states) {
//             if (product.cat.color != Colors.white) {
//               return product.cat.color;
//             } else {
//               return Colors.black12;
//             }
//           },
//         ),
//       ),
//       onPressed: () => {},
//       child: Text(
//         product.ingredient.ingredient.name,
//         style: TextStyle(fontSize: 12),
//       ),
//     ),
//   );
// }
}
