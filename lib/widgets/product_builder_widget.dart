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
        borderRadius: BorderRadius.circular(10),
        border: Border.all(width: 2, color: borderColor),
      ),
    );
  }
}


class AnimatedTextButton extends ImplicitlyAnimatedWidget {
  /// {@macro animated_text_button}
  const AnimatedTextButton({
    Key? key,
    required this.child,
    required this.style,
    required this.onPressed,
    required Duration duration,
    Curve curve = Curves.linear,
    VoidCallback? onEnd,
  }) : super(key: key, curve: curve, duration: duration, onEnd: onEnd);

  /// Typically the button's label.
  final Widget child;

  /// Called when the button is tapped or otherwise activated.
  final VoidCallback? onPressed;

  /// The target text style of this button, must not be null.
  ///
  /// When this property is changed, the style will
  /// be animated over [duration] time.
  final ButtonStyle style;

  @override
  AnimatedWidgetBaseState<AnimatedTextButton> createState() =>
      _AnimatedTextButtonState();
}

class _AnimatedTextButtonState
    extends AnimatedWidgetBaseState<AnimatedTextButton> {
  ButtonStyleTween? _style;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _style = visitor(
      _style,
      widget.style,
          (dynamic value) => ButtonStyleTween(begin: value as ButtonStyle),
    ) as ButtonStyleTween?;
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: _style!.evaluate(animation),
      onPressed: widget.onPressed,
      child: widget.child,
    );
  }
}

/// The tween for [ButtonStyle].
class ButtonStyleTween extends Tween<ButtonStyle> {
  /// Creates a button style tween.
  ///
  /// The [begin] and [end] properties must be non-null before the tween is
  /// first used, but the arguments can be null if the values are going to be
  /// filled in later.
  ButtonStyleTween({ButtonStyle? begin, ButtonStyle? end})
      : super(begin: begin, end: end);

  /// Returns the value this variable has at the given animation clock value.
  @override
  ButtonStyle lerp(double t) => ButtonStyle.lerp(begin, end, t)!;
}