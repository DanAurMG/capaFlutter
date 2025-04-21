import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/model/recipe_model.dart';
import 'package:recipe_book/providers/recipes_provider.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipesData;
  const RecipeDetail({super.key, required this.recipesData});

  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> with SingleTickerProviderStateMixin {
  bool isFavorite = false;

  late AnimationController _controller;
  late Animation<double> _scaleAnimationM;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this,
      duration: Duration(milliseconds: 300)
    );

    _scaleAnimationM = Tween<double>(begin: 1.0, end: 1.5).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut)..addStatusListener((status){
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    }));
  }

  @override
  void didChangeDeps() {
    super.didChangeDependencies();
    isFavorite = Provider.of<RecipesProvider>(
      context,
      listen: false,
    ).favoritesRecipe.contains(widget.recipesData);
  }

  @override
  void dispose(){
    _controller.dispose();
    super.dispose();    
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipesData.nombre,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 252, 124, 86),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color.fromARGB(255, 0, 0, 0),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await Provider.of<RecipesProvider>(
                context,
                listen: false,
              ).toggleFavStat(widget.recipesData);
              setState(() {
                isFavorite = !isFavorite;
              });
            },
            icon: AnimatedSwitcher(
            // Comentar para animación personalizada (no jaló)
            // icon: ScaleTransition(
              // scale: _scaleAnimationM,
              duration: Duration(milliseconds: 500),
              transitionBuilder: (child, animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Icon(
                isFavorite ? Icons.favorite 
                : Icons.favorite_border,
                // Comentar para animación personalizada (no jaló)
                key: ValueKey<bool>(isFavorite),
                color: Colors.red,
                ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Column(
          children: [
            Image.network(widget.recipesData.image_link),
            SizedBox(height: 8),
            Text(widget.recipesData.nombre),
            SizedBox(height: 8),
            Text("by ${widget.recipesData.autor}"),
            SizedBox(height: 8),
            const Text('Recipe steps: '),
            for (var step in widget.recipesData.procedimiento) Text("- $step"),
          ],
        ),
      ),
    );
  }
}
