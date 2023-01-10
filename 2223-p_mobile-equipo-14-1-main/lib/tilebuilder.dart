import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:recipes_app/providers.dart';
import 'package:recipes_app/twoscreendesign.dart';
import 'package:stack/stack.dart' as Stack1;

class TileBuilder {
  //se puede sacar a widgets a parte siendo stateless
  @override
  static Widget tileBuilderMovil(BuildContext context, Recipe data) {
    final TextStyle fontStyle =
        TextStyle(fontSize: Theme.of(context).textTheme.headline5?.fontSize);
    return Card(
      borderOnForeground: true,
      elevation: 5.0,
      child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          leading: CircleAvatar(
              child: Image.network(
                  data.image.toString()) //ver como añadir la imagen
              ),
          title: Text(data.label.toString(), style: fontStyle),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => MovilAppSecondPage(data: data)));
          }),
    );
  }

  @override
  static Widget tileBuilderTablet(BuildContext context, Recipe data) {
    final TextStyle fontStyle =
        TextStyle(fontSize: Theme.of(context).textTheme.headline5?.fontSize);
    return Card(
      borderOnForeground: true,
      elevation: 5.0,
      child: ListTile(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          leading: CircleAvatar(
              child: Image.network(
                  data.image.toString()) //ver como añadir la imagen
              ),
          title: Text(data.label.toString(), style: fontStyle),
          onTap: () {
            context.read<VariablesTablet>().setRecipe(data);
          }),
    );
  }
  /*A la pregunta de si se podría implementar esto como un StatelessWidget, poder a lo mejor se podría,
  pero tal como tenemos la implementación supondría bastantes cambios del código, además esto es tal como
  lo hacen en el ejemplo que nos dieron de perretesApp*/
}
