import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/providers/recipes_provider.dart';
import 'package:recipe_book/screens/favorites_recipes.dart';
import 'package:recipe_book/screens/home_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => RecipesProvider())],
      child: 
        const MaterialApp(
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          title: "Hola mundo App",
          home: RecipeBook(),
        ),
    );
  }
}

class RecipeBook extends StatelessWidget {
  const RecipeBook({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
      appBar: AppBar( 
        title: Text("Recipe book by Aurelio", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 36, 122, 46),
        bottom: TabBar(tabs:  [Tab(icon: Icon(Icons.home), text: "Home", ), Tab(icon: Icon(Icons.favorite), text: "Liked",)]),
      ),
      body: TabBarView(children: [HomeScreen(), FavoritesRecipes() ])    
    )
  );
  }
}
