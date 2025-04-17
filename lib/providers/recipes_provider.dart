import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:recipe_book/model/recipe_model.dart';

class RecipesProvider extends ChangeNotifier {
  bool isLoading = false;
  List<Recipe> recipes = [];

  Future<void> FetchRecipes() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.parse("http://localhost:3000/recipes");
    try {
      final response = await http.get(url);
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        recipes = List<Recipe>.from(data["recetas"].map((recipe) => Recipe.fromJSON(recipe)));
      }else{
        print("Error ${response.statusCode}");
        recipes = [];
      }
    } catch (e) {
      print("Error en solicitud ${e}");
      recipes = [];
    }
    finally{
      isLoading = false;
      notifyListeners();
    }
  }
}