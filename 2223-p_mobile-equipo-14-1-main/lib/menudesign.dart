import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:recipes_app/providers.dart';
import 'package:recipes_app/twoscreendesign.dart';
import 'package:stack/stack.dart' as Stack1;

class SearchBars extends StatelessWidget {
  //variable de la barra de busqueda
  TextEditingController searchController = TextEditingController();
  //variable del desplegable
  List<String> optionsdropdownbutton = <String>[
    "balanced",
    "high-fiber",
    "high-protein",
    "low-carb",
    "low-fat",
    "low-sodium"
  ];

  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle =
        TextStyle(fontSize: Theme.of(context).textTheme.headline6?.fontSize);
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Color.fromARGB(255, 240, 237, 237),
      //alignment: Alignment.center,
      child: Column(
        //texto de busqueda
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              "Recipe:",
              style: fontStyle,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          TextField(
            //searchBar
            key: Key("searchBar"),
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: "Receta.."),
            onSubmitted: (value) {
              context.read<VariablesProvider>().setSearch(value.toString());
            },
            onChanged: (value) {
              context.read<VariablesProvider>().setSearch(value.toString());
            },
          ),
          Align(
              //texto de diet
              alignment: Alignment.bottomLeft,
              child: Text("Diet:", style: fontStyle)),
          Row(
            //columna con boton y desplegable
            children: [
              Expanded(
                //dropdown
                child: Container(
                    child: DropdownButton<String>(
                  key: Key("dropdown"),
                  items: optionsdropdownbutton
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                        value: value, child: Text(value));
                  }).toList(),
                  value: context
                      .watch<VariablesProvider>()
                      .diet, //para que cuando se produzca un cambio se recargue la pagina
                  isExpanded: true,
                  //icon: se puede poner un icono
                  onChanged: (String? diet) {
                    context.read<VariablesProvider>().setDiet(
                        diet.toString()); //cuando se cambvia entonces avises
                  },
                )),
              ),
              Expanded(
                //boton de buscar
                child: ElevatedButton(
                    child: Text("SEARCH"),
                    onPressed: () {
                      context
                          .read<VariablesProvider>()
                          .setSearchAndDiet(); //ya se han seteado antes ahora avisamos que busque con los valores introducidos
                    }),
              ),
            ],
          ),
          /*Divider( mirar si dejarlo o no
            color: Colors.grey,
          )*/
        ],
      ),
    );
  }
}

class ListRecipes extends StatelessWidget {
  final Widget Function(BuildContext context, Recipe data) tileBuilder;
  ListRecipes({required this.tileBuilder});
  @override
  Widget build(BuildContext context) {
    //aprovechamos que este widget siempre se reconstruye para que sea el que sace los mensajes de error
    bool error = context.watch<VariablesProvider>().readError();
    List<String> data2 = context.watch<VariablesProvider>().getMsgError8();
    Future.delayed(Duration.zero, (() {
      if (error) {
        showDialog(
            context: context,
            builder: ((context) => AlertDialog(
                  title: Text(data2[0]),
                  content: Text(data2[1]),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("OK"))
                  ],
                )));
      }
    }));

    List<Recipe> data = context.watch<VariablesProvider>().gList;
    return Expanded(
        child: (context.watch<VariablesProvider>().spinner)
            ? Center(
                child: Container(
                    width: 30, height: 30, child: CircularProgressIndicator()),
              )
            : ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int i) =>
                    tileBuilder(context, data[i]),
              ));
  }
}

class ButtonsPages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: OutlinedButton(
                onPressed: () {
                  context.read<VariablesProvider>().loadPrev();
                },
                child: Text("< Prev"))),
        Expanded(
            child: OutlinedButton(
                onPressed: () {
                  context.read<VariablesProvider>().loadNext();
                },
                child: Text("Next >"))),
      ],
    );
  }
}
