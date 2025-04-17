class Recipe {
    String nombre;
    String autor;
    String image_link;
    List<String> procedimiento; 

    Recipe({
      required this.nombre,
      required this.autor,
      required this.image_link,
      required this.procedimiento,
    });

    factory Recipe.fromJSON(Map<String, dynamic> json){
      return Recipe(nombre: json["nombre"], autor: json["autor"], image_link: json["image_link"], procedimiento: List<String>.from(json["procedimiento"]));
    }

    Map<String, dynamic> toJSON(){
      return {
        'nombre': nombre,
        'autor': autor,
        'image_link': image_link,
        'procedimiento': procedimiento,
      };
    }

    @override
  String toString(){
    return 'Recipe{name: $nombre, autor: $autor, image_link: $image_link, procedimiento: $procedimiento}';
  }
}