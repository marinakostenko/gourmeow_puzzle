import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gourmeow_puzzle/models/meal.dart';
import 'package:gourmeow_puzzle/models/recipe.dart';
import 'package:gourmeow_puzzle/recipes/bloc/recipes_bloc.dart';

class Recipes extends StatelessWidget {
  final Cuisine cuisine;

  const Recipes({Key? key, required this.cuisine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double ratio = size.width / size.height;
    double iconSize = ratio < 1 ? size.width * 0.05 : size.height * 0.05;

    return Material(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(iconSize * 0.1),
        child: IconButton(
          onPressed: () => {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return RecipesModal(
                    cuisine: cuisine,
                  );
                }),
          },
          icon: Icon(
            Icons.book_rounded,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class RecipesModal extends StatefulWidget {
  final Cuisine cuisine;

  const RecipesModal({Key? key, required this.cuisine}) : super(key: key);

  @override
  _RecipesModalState createState() => _RecipesModalState();
}

class _RecipesModalState extends State<RecipesModal> {
  dynamic size;
  dynamic dialogWidth;
  dynamic dialogHeight;
  dynamic cuisine = Cuisine.none;
  dynamic ratio;
  dynamic iconSize;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    ratio = size.width / size.height;

    cuisine = widget.cuisine;
    dialogWidth = ratio < 1 ? size.width * 0.95 : size.width * 0.7;
    dialogHeight = ratio < 1 ? size.height * 0.8 : size.height * 0.9;
    iconSize = ratio < 1 ? size.width * 0.15 : size.height * 0.2;

    return BlocProvider<RecipesBloc>(
      create: (context) {
        return RecipesBloc()..add(RecipesInitialized(cuisine));
      },
      child: BlocBuilder<RecipesBloc, RecipesState>(
        builder: (context, state) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
            insetPadding: const EdgeInsets.all(0.0),
            backgroundColor: Colors.transparent,
            child: Container(
              height: dialogHeight,
              width: dialogWidth,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).colorScheme.primaryVariant,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(width: 5, color: Colors.white),
              ),
              child: _dialogView(state.recipes),
            ),
          );
        },
      ),
    );
  }

  Widget _dialogView(List<Recipe> recipes) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: recipes.length,
            itemBuilder: (BuildContext context, int index) {
              return _recipeRow(recipes[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _recipeRow(Recipe recipe) {
    return Container(
      margin: const EdgeInsets.all(30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            alignment: Alignment.center,
            height: iconSize,
            width: iconSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: recipe.mealImage,
                alignment: Alignment.center,
                repeat: ImageRepeat.noRepeat,
              ),
              color: recipe.dishColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: iconSize * 0.3,
            height: iconSize,
            child: Text(
              "=",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: iconSize,
            width: iconSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: recipe.ingredientsImages[0],
                alignment: Alignment.center,
                repeat: ImageRepeat.noRepeat,
              ),
              color: recipe.dishColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: iconSize * 0.3,
            height: iconSize,
            child: Text(
              "+",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: iconSize,
            width: iconSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: recipe.ingredientsImages[1],
                alignment: Alignment.center,
                repeat: ImageRepeat.noRepeat,
              ),
              color: recipe.dishColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          Container(
            alignment: Alignment.center,
            width: iconSize * 0.3,
            height: iconSize,
            child: Text(
              "+",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: iconSize,
            width: iconSize,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: recipe.ingredientsImages[2],
                alignment: Alignment.center,
                repeat: ImageRepeat.noRepeat,
              ),
              color: recipe.dishColor,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ],
      ),
    );
  }
}
