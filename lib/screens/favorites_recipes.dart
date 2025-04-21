import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/model/recipe_model.dart';
import 'package:recipe_book/providers/recipes_provider.dart';
import 'package:recipe_book/screens/recipe_detail.dart';

class FavoritesRecipes extends StatefulWidget {
  const FavoritesRecipes({super.key});

  @override
  State<FavoritesRecipes> createState() => _FavoritesRecipesState();
}

class _FavoritesRecipesState extends State<FavoritesRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<RecipesProvider>(
        builder: (context, recipeProvider, child) {
          final favoritesRecipes = recipeProvider.favoritesRecipe;

          return favoritesRecipes.isEmpty
              ? Center(child: Text("No favorites recipes yet"))
              : ListView.builder(
                itemCount: favoritesRecipes.length,
                itemBuilder: (context, index) {
                  print(favoritesRecipes);
                  final recipe = favoritesRecipes[index];
                  // return Center(child: Text("$recipe"));
                  return FavoriteCard(recipe: recipe);
                },
              );
        },
      ),
    );
  }
}

class FavoriteCard extends StatelessWidget {
  final Recipe recipe;
  const FavoriteCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipesData: recipe),
          ),
        );
      },
      child: Semantics(
        label: "Tarjeta de recetas",
        hint: "Toca para ver detalle de receta ${recipe.nombre}",
        child: Card(
          color: Colors.amber,
          child: Column(children: [Text(recipe.nombre), Text(recipe.autor)]),
        ),
      ),
    );
  }
}
