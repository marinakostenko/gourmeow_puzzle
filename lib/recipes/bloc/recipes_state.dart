part of 'recipes_bloc.dart';

class RecipesState extends Equatable {
  final List<Recipe> recipes;

  const RecipesState({
    this.recipes = const <Recipe>[],
  });

  RecipesState copyWith({
    List<Recipe>? recipes,
  }) {
    return RecipesState(
      recipes: recipes ?? this.recipes,
    );
  }

  @override
  List<Object?> get props => [
        recipes,
      ];
}
