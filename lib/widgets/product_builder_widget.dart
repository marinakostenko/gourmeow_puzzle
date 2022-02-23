import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gourmeow_puzzle/models/ingredient.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/product.dart';

class ProductBuilder extends StatelessWidget {
  final Product product;
  final Size size;

  const ProductBuilder({Key? key, required this.product, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _productCard(product);
  }

  Widget _productCard(Product product) {
    String productName = product.ingredient.ingredient.name;
    AssetImage image = product.ingredient.ingredient.ingredientImage;

    if (product.meal.meal != Meals.none) {
      productName = product.meal.meal.name;
      image = product.meal.meal.mealImage;
    }

    Color backgroundColor = (product.cat.color != Colors.white)
        ? product.cat.color
        : Colors.blueGrey;
    Color borderColor =
        (product.isSelected) ? Colors.yellow : Colors.transparent;

    if (product.ingredient.ingredient == Ingredients.none &&
        product.meal.meal == Meals.none) {
      productName = "";
      backgroundColor = (product.cat.color != Colors.white)
          ? product.cat.color
          : Colors.transparent;
      borderColor = Colors.transparent;
    }

    return Container(
      alignment: Alignment.center,
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: image,
          alignment: Alignment.center,
          fit: BoxFit.fill,
          repeat: ImageRepeat.noRepeat,
        ),
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 2, color: borderColor),
      ),
    );
  }
}
