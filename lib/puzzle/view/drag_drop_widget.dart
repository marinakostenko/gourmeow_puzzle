import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

class DragDrop extends StatelessWidget {
  final Product product;
  final Function onDragStart;
  final Function onDragEnd;
  final Function onDragAccept;

  const DragDrop({Key? key,
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
        feedback: _productCard(product, Colors.white),
        onDragStarted: () async {
          onDragStart(product);
        },

        childWhenDragging: Container(),
        child: _productCard(product, Colors.white),
      );
    }

    if (product.draggable == Drag.drop) {
      return DragTarget<Product>(
        builder: (context, candidateItems, rejectedItem) {
          return _productCard(product, Colors.indigo);
        },
        onAccept: (Product targetProduct) {
          onDragAccept(product, targetProduct);
        },
      );
    }

    return Container();
  }

  Widget _productCard(Product product, Color textColor) {
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
        style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }
}
