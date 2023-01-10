import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:recipes_app/inforecipe.dart';
import 'package:recipes_app/menudesign.dart';
import 'package:recipes_app/tilebuilder.dart';
import 'package:stack/stack.dart' as Stack1;

class MovilApp extends StatelessWidget {
  final String title;
  const MovilApp({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle =
        TextStyle(fontSize: Theme.of(context).textTheme.headline4?.fontSize);
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 237, 237),
        appBar: AppBar(title: Center(child: Text(this.title))),
        body: Column(
          children: <Widget>[
            SearchBars(),
            ListRecipes(tileBuilder: TileBuilder.tileBuilderMovil),
            ButtonsPages(),
          ],
        ));
  }
}

class MovilAppSecondPage extends StatelessWidget {
  //implementar con Scaffold
  //construir segunda pagina
  final Recipe data;
  MovilAppSecondPage({required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(data.label.toString()),
        ),
      ),
      body: InfoRecipe(data: data),
    );
  }
}
