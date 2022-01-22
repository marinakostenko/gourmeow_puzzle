import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/puzzle/models/product.dart';

class Puzzle extends Equatable {
  final List<List<Product>> products;

  const Puzzle(this.products);

  int getDimension() {
    return sqrt(products.length).toInt();
  }

  @override
  List<Object?> get props => [products];
}