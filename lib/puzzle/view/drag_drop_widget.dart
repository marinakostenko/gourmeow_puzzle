import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

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
        feedback: _productCard(product, Colors.black),
        onDragStarted: () async {
          onDragStart(product);
        },
        childWhenDragging: Container(),
        child: _productCard(product, Colors.black),
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
    String productName = product.ingredient.ingredient.name;

    if(product.meal.meal != Meals.none) {
      productName = product.meal.meal.name;
    }

    Color backgroundColor = (product.cat.color != Colors.white)
        ? product.cat.color
        : Colors.black12;
    Color borderColor = (product.isSelected) ? Colors.yellow : Colors.black12;

    if(product.ingredient.ingredient == Ingredients.none && product.meal.meal == Meals.none) {
      productName = "";
      backgroundColor = (product.cat.color != Colors.white)
          ? product.cat.color
          : Colors.white;
      borderColor = Colors.white;
    }

    return Container(
      alignment: Alignment.center,
      height: 20,
      width: 20,
      decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 2, color: borderColor)),
      child: Text(
        productName,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: textColor),
      ),
    );
  }
}
