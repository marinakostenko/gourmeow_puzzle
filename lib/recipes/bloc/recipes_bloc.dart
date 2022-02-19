import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gourmeow_puzzle/data/data.dart';
import 'package:gourmeow_puzzle/models/recipe.dart';

part 'recipes_event.dart';
part 'recipes_state.dart';

class RecipesBloc extends Bloc<RecipesEvent, RecipesState> {
  RecipesBloc() : super(const RecipesState()) {
    on<RecipesInitialized>(_onRecipesInitialized);
  }

  List<Recipe> recipes = [];

  void _onRecipesInitialized(
      RecipesInitialized event,
      Emitter<RecipesState> emit,
      ) {

    recipes = Data().recipesList();

    emit(
      RecipesState(
        recipes: recipes,
      ),
    );
  }

}
