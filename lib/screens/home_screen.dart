import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/providers/recipes_provider.dart';
import 'package:recipe_book/screens/recipe_detail.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State  createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      Provider.of<RecipesProvider>(context, listen: false).FetchRecipes()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RecipesProvider>(
        builder: (context, provider, child) {
          if(provider.isLoading){
            return const Center(child: CircularProgressIndicator(),);
          }else if(provider.recipes.isEmpty){
            return Center(child: Text(AppLocalizations.of(context)!.noReceipts),);
          }else {
            return ListView.builder(
              itemCount: provider.recipes.length,
              itemBuilder: (context, index) {
                return _recipesCard(context, provider.recipes[index]);
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showBotton(context);
        },
      ),
    );
  }

  Future<void> _showBotton(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => FocusScope.of(context).unfocus(),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
                height: 500,
                width: MediaQuery.of(context).size.width,
                color: const Color.fromARGB(255, 248, 255, 248),
                child: const RecipeForm(),
              ),
            ),
          ),
    );
  }

  Widget _recipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(recipesData: recipe),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 125,
          child: Card(
            child: Row(
              children: <Widget>[
                Container(
                  height: 125,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      recipe.image_link,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 26),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      recipe.nombre,
                      style: TextStyle(fontSize: 16, fontFamily: "Quicksand"),
                    ),
                    SizedBox(height: 4),
                    Container(
                      height: 3,
                      width: 75,
                      color: const Color.fromARGB(255, 106, 177, 23),
                    ),
                    Text(
                      recipe.autor,
                      style: TextStyle(fontSize: 14, fontFamily: "helvetica"),
                    ),
                    SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecipeForm extends StatelessWidget {
  const RecipeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _recipeName = TextEditingController();
    final TextEditingController _authorName = TextEditingController();
    final TextEditingController _recipeImg = TextEditingController();
    final TextEditingController _recipeDesc = TextEditingController();

    return Padding(
      padding: EdgeInsets.all(8),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Aquí agregar nueva receta",
              style: TextStyle(color: Colors.blueGrey, fontSize: 20),
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeName,
              label: "Recipe name",
              validator: (value) {
                if ((value == null) || value.isEmpty) {
                  return "Introduce el nombre de la receta";
                } else
                  return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _authorName,
              label: "Author name",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Introduce el nombre del autor";
                } else {
                  return null;
                }
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              controller: _recipeImg,
              label: "Url de la imagen",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa el url de la imagen";
                } else
                  return null;
              },
            ),
            SizedBox(height: 16),
            _buildTextField(
              maxLines: 2,
              controller: _recipeDesc,
              label: "Receta",
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Ingresa los detalles de la receta";
                } else
                  return null;
              },
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Guardar receta",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: "helvetica", color: Colors.grey),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.deepPurple, width: 3),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      validator: validator,
      maxLines: maxLines,
    );
  }
}
