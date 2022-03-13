import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:gourmeow_puzzle/data/data.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/product.dart';

class Puzzle extends Equatable {
  final List<List<Product>> products;

  const Puzzle({required this.products});

  int getDimension() {
    return sqrt(products.length).toInt();
  }

  @override
  List<Object?> get props => [products];

  Product getWhitespaceTile() {
    Product defaultProduct = Data().defaultProduct;

    for (int y = 0; y < products.length; y++) {
      for (int x = 0; x < products[0].length; x++) {
        Ingredients ingredient = products[y][x].ingredient.ingredient;
        if (ingredient == Ingredients.none) {
          return products[y][x];
        }
      }
    }
    return defaultProduct;
  }

  bool isComplete() {
    return false;
  }

  bool isTileMovable(Product productTile) {
    final whitespaceTile = getWhitespaceTile();
    if (productTile.ingredient.ingredient ==
        whitespaceTile.ingredient.ingredient) {
      return false;
    }

    if ((whitespaceTile.position.x == productTile.position.x - 1 &&
            whitespaceTile.position.y == productTile.position.y) ||
        (whitespaceTile.position.x == productTile.position.x + 1 &&
            whitespaceTile.position.y == productTile.position.y) ||
        (whitespaceTile.position.x == productTile.position.x &&
            whitespaceTile.position.y == productTile.position.y - 1) ||
        (whitespaceTile.position.x == productTile.position.x &&
            whitespaceTile.position.y == productTile.position.y + 1)) {
      return true;
    }

    return false;
  }
}
