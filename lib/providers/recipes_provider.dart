import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_book/model/recipe_model.dart';

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> recipes = [];
  List<Recipe> favoritesRecipe = [];

  Future<void> FetchRecipes() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse("http://localhost:3000/recipes");
    try {
      print(url);
      final response = await http.get(url);
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        recipes = List<Recipe>.from(data["recetas"].map((recipe) => Recipe.fromJSON(recipe)));
      }else{
        print("Error ${response.statusCode}");
        print(recipes);
        recipes = [];
      }
    } catch (e) {
      print("Error en solicitud $e");
      recipes = [];
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavStat(Recipe recipe) async {
    final isFavorite = favoritesRecipe.contains(recipe);

    try {
      final url = Uri.parse("http://localhost:3000/favorites");  
      final response = isFavorite ?
        await http.delete(url, body: json.encode({"id": recipe.id}))
        : await http.post(url, body: json.encode(recipe.toJSON()));
        if(response.statusCode == 200){
          isFavorite ? favoritesRecipe.remove(recipe) : favoritesRecipe.add(recipe);
          notifyListeners();
        }else{
          throw Exception("Failed while updating favorite recipes");
        }
    } catch (e) {
      print('Error updating recipe status $e');
    }
  }
}