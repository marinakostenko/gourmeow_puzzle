part of 'recipes_bloc.dart';

abstract class RecipesEvent extends Equatable {
  const RecipesEvent();

  @override
  List<Object> get props => [];
}

class RecipesInitialized extends RecipesEvent {
  final Cuisine cuisine;
  const RecipesInitialized(this.cuisine);

  @override
  List<Object> get props => [cuisine];
}