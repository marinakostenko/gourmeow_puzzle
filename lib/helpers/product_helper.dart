import 'dart:math';

import 'package:gourmeow_puzzle/models/board_position.dart';
import 'package:gourmeow_puzzle/models/product.dart';

class ProductHelper {
  List<List<Product>> shuffleProducts(
      int dimension, List<List<Product>> products) {
    final List<List<Product>> sortedProducts = [];
    for (int y = 0; y < dimension; y++) {
      var productsList = <Product>[];
      for (int x = 0; x < dimension; x++) {
        Product product = products[y][x].copyWith();
        productsList.add(product);
      }
      sortedProducts.add(productsList);
    }

    final List<List<Product>> shuffleProducts = [];
    final _random = Random();

    for (int y = 1; y <= dimension; y++) {
      var shuffledX = <Product>[];
      for (int x = 1; x <= dimension; x++) {
        var currentProduct = sortedProducts[y - 1][x - 1];

        int randomY = _random.nextInt(products.length);
        int randomX = _random.nextInt(products[randomY].length);

        var product = products.elementAt(randomY).elementAt(randomX);

        product.position = BoardPosition(x: x, y: y);
        product.cat = currentProduct.cat;

        shuffledX.add(product);

        products.elementAt(randomY).removeAt(randomX);
        if (products.elementAt(randomY).isEmpty) {
          products.removeAt(randomY);
        }
      }
      shuffleProducts.add(shuffledX);
    }

    return shuffleProducts;
  }
}