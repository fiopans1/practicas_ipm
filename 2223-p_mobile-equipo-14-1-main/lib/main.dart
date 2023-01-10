import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:recipes_app/twoscreendesign.dart';
import 'package:stack/stack.dart' as Stack1;
import 'package:recipes_app/tilebuilder.dart';
import 'package:recipes_app/inforecipe.dart';
import 'package:recipes_app/providers.dart';
import 'package:recipes_app/menudesign.dart';

import 'onescreendesign.dart';

//para instalar el stack:

//CONSTANTES:
// ignore: constant_identifier_names
const String APP_TITLE = "RecipesApp";
const int breakPoint = 600;
void main() {
  runApp(ChangeNotifierProvider(
      create: (_) => VariablesProvider(),
      child: const RecipesApp(title: APP_TITLE)));
}

//VARIABLES-------------------------------------------------------------------------------------

//MAIN-------------------------------------------------------------------------------------
class RecipesApp extends StatelessWidget {
  final String title;
  const RecipesApp({super.key, required this.title});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: this.title,
      theme: ThemeData(
        //primarySwatch: Colors.red, //cambiar color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DecisionApp(title: this.title),
    );
  }
}

class DecisionApp extends StatelessWidget {
  final String title;
  const DecisionApp({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      bool phoneOrTablet = ( //booleano que decide que version lanzar
          constraints.smallest.longestSide > breakPoint &&
              MediaQuery.of(context).orientation == Orientation.landscape);
      if (!phoneOrTablet) {
        return MovilApp(title: this.title);
      } else {
        return TabletApp(title: this.title);
      }
    });
  }
}
