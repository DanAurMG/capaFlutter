import 'package:flutter/material.dart';


class RecipeDetail extends StatelessWidget {
  final String recipeName;
  const RecipeDetail({super.key, required this.recipeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipeName),
        backgroundColor: const Color.fromARGB(255, 252, 124, 86),
        leading: IconButton(onPressed: () {Navigator.pop(context);}, color: const Color.fromARGB(255, 0, 0, 0), icon: Icon(Icons.arrow_back)),
      ),
    );
  }
}