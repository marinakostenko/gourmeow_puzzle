import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';
import 'package:gourmeow_puzzle/widgets/product_builder_widget.dart';

class DragDrop extends StatelessWidget {
  final Product product;
  final Function onDragStart;
  final Function onDragEnd;
  final Function onDragAccept;

  const DragDrop(
      {Key? key,
      required this.product,
      required this.onDragStart,
      required this.onDragEnd,
      required this.onDragAccept})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (product.draggable == Drag.drag) {
      return Draggable<Product>(
        maxSimultaneousDrags: 1,
        data: product,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        feedback: ProductBuilder(product: product, size: Size(50, 50),),
        onDragStarted: () async {
          onDragStart(product);
        },
        childWhenDragging: Container(),
        child: ProductBuilder(product: product, size: Size(50, 50)),
      );
    }

    if (product.draggable == Drag.drop) {
      return DragTarget<Product>(
        builder: (context, candidateItems, rejectedItem) {
          return ProductBuilder(product: product, size: Size(50, 50));
        },
        onAccept: (Product targetProduct) {
          onDragAccept(product, targetProduct);
        },
      );
    }

    return Container();
  }
}
