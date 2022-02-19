import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
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

  /// Gets the single whitespace tile object in the puzzle.
  Product getWhitespaceTile() {
    Product defaultProduct = Data().defaultProduct;
    for(int y = 0; y < products.length; y++) {
      for(int x = 0; x <products[0].length; x++) {
        Ingredients ingredient = products[y][x].ingredient.ingredient;
        if(ingredient == Ingredients.none) {
          return products[y][x];
        }
      }
    }
    return defaultProduct;
  }

  /// Determines if the puzzle is completed.
  bool isComplete() {
    return false;//(tiles.length - 1) - getNumberOfCorrectTiles() == 0;
  }

  /// Determines if the tapped tile can move in the direction of the whitespace
  /// tile.
  bool isTileMovable(Product productTile) {
    final whitespaceTile = getWhitespaceTile();
    if (productTile.ingredient.ingredient == whitespaceTile?.ingredient.ingredient) {
      return false;
    }

    // A tile must be in the same row or column as the whitespace to move.
    if (whitespaceTile?.position.x != productTile.position.x &&
        whitespaceTile?.position.y != productTile.position.y) {
      return false;
    }
    return true;
  }
}