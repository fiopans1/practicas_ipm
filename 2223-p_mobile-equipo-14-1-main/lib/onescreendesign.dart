import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:recipes_app/providers.dart';
import 'package:recipes_app/tilebuilder.dart';
import 'package:stack/stack.dart' as Stack1;

import 'inforecipe.dart';
import 'menudesign.dart';

class TabletApp extends StatelessWidget {
  final String title;
  const TabletApp({super.key, required this.title});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => VariablesTablet(), child: DesignTablet(title: title));
  }
}

class DesignTablet extends StatelessWidget {
  const DesignTablet({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return Scaffold(
        appBar: AppBar(title: Center(child: Text(this.title))),
        body: Row(
          children: [
            Container(
              color: Color.fromARGB(255, 240, 237, 237),
              width: queryData.size.width * (2 / 5), //ocupa 2/5 de la pantalla
              child: Column(
                children: [
                  SearchBars(),
                  ListRecipes(tileBuilder: TileBuilder.tileBuilderTablet),
                  ButtonsPages()
                ],
              ),
            ),
            Expanded(
                child: Center(
              child: SingleChildScrollView(
                child: (context.watch<VariablesTablet>().isNull())
                    ? Center(
                        child: Text("INFORMACIÓN RECETA"),
                      )
                    : InfoRecipe(data: context.watch<VariablesTablet>().data),
              ),
            ))
          ],
        ));
  }
}
