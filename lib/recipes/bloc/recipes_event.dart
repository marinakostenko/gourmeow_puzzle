part of 'recipes_bloc.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object> get props => [];
}

class RecipesInitialized extends RecipesEvent {
  const RecipesInitialized();

  @override
  List<Object> get props => [];
}