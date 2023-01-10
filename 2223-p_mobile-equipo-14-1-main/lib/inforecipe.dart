import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:recipes_app/providers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:stack/stack.dart' as Stack1;

class InfoRecipe extends StatelessWidget {
  const InfoRecipe({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Recipe data;

  @override
  Widget build(BuildContext context) {
    final TextStyle fontStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.headline4?.fontSize,
        fontWeight: FontWeight.bold);
    return SingleChildScrollView(
      child: Column(
        verticalDirection: VerticalDirection.down,
        children: [
          Center(child: Text("\n${data.label}:\n", style: fontStyle)),
          Center(child: Image.network(data.image.toString())),
          Info(data: this.data),
        ],
      ),
    );
  }
}

class Info extends StatelessWidget {
  Info({required this.data});
  Recipe data;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
            child: ChangeNotifierProvider(
                create: (_) => VariablesInfo(),
                child: InfoPannel(data: data))));
  }
}

class InfoPannel extends StatelessWidget {
  InfoPannel({required this.data});
  Recipe data;
  @override
  Widget build(BuildContext context) {
    String datos = """
    DietLabels: ${(data.dietLabels == null) ? "No Information" : format(data.dietLabels, 3)}
    Calories: ${(data.calories == null) ? "No Information" : format2(data.calories.toString())} kcal
    TotalC02Emissions: ${(data.totalCO2Emissions == null) ? "No Information" : format2(data.totalCO2Emissions.toString())}
    CO2EmissionsClass: ${(data.co2EmissionsClass == null) ? "No Information" : data.co2EmissionsClass.toString()}
    TotalTime: ${(data.totalTime == 0) ? "No Information" : format2(data.totalTime.toString())} min
    CuisuneType: ${(data.cuisineType == null) ? "No Information" : format3(data.cuisineType)}
    MealType: ${(data.mealType == null) ? "No Information" : format3(data.mealType)}
    DishType: ${(data.dishType == null) ? "No Information" : format3(data.dishType)}
    Cautions: ${(data.cautions == null) ? "No Information" : format3(data.cautions)}
    GlycemicIndex: ${(data.glycemicIndex == null) ? "No Information" : format2(data.glycemicIndex.toString())}
    """;
    final TextStyle fontStyle = TextStyle(
        fontSize: Theme.of(context).textTheme.headline4?.fontSize,
        fontWeight: FontWeight.bold);
    final TextStyle fontStyle2 = TextStyle(
        fontSize: Theme.of(context).textTheme.headline6?.fontSize,
        fontWeight: FontWeight.bold);
    final TextStyle fontStyle3 = TextStyle(
        fontSize: Theme.of(context).textTheme.titleMedium?.fontSize,
        fontWeight: FontWeight.bold);

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        context.read<VariablesInfo>().changeExpanded(!isExpanded, index);
      },
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              key: Key("url"),
              title: Text("URL recipe:", style: fontStyle3),
            );
          },
          body: ListTile(
            title: Text(
              data.source.toString(),
              key: Key("url2"),
            ),
            onTap: ((() async {
              launchUrl(Uri.parse(data.sourceUrl.toString()));
            })),
          ),
          isExpanded: context.watch<VariablesInfo>().items[0],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("Nutritional Information", style: fontStyle3),
            );
          },
          body: ListTile(title: Text(datos)),
          isExpanded: context.watch<VariablesInfo>().items[1],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("List of ingredients", style: fontStyle3),
            );
          },
          body: ListTile(title: Text("${format(data.ingredients, 1)}\n")),
          isExpanded: context.watch<VariablesInfo>().items[2],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("health labels", style: fontStyle3),
            );
          },
          body: ListTile(title: Text("${format(data.healthLabels, 3)}\n\n")),
          isExpanded: context.watch<VariablesInfo>().items[3],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("Total Nutrients", style: fontStyle3),
            );
          },
          body: ListTile(
              title: Text(
                  "${data.totalNutrients.toString().replaceAll("[", "").replaceAll("]", "")}\n\n")),
          isExpanded: context.watch<VariablesInfo>().items[4],
        ),
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("Total Daily Nutrients", style: fontStyle3),
            );
          },
          body: ListTile(
              title: Text(
                  "${data.totalDaily.toString().replaceAll("[", "").replaceAll("]", "")}\n\n")),
          isExpanded: context.watch<VariablesInfo>().items[5],
        )
      ],
    );
  }

  String format(List<String>? text, int max) {
    StringBuffer buffer = StringBuffer();
    int j = 0;
    for (int i = 0; i < text!.length; i++) {
      j++;
      if (i < text.length - 1) {
        buffer.write("${text[i]},");
      } else {
        buffer.write(text[i]);
      }
      if (j == max) {
        buffer.write("\n");
        j = 0;
      }
    }

    return buffer.toString();
  }

  String format2(String? text) {
    return double.parse(text.toString()).toStringAsFixed(2);
  }

  String format3(List<String>? text) {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < text!.length; i++) {
      if (i < text.length - 1) {
        buffer.write("${text[i]},");
      } else {
        buffer.write(text[i]);
      }
    }

    return buffer.toString();
  }

  String formatNutrient(List<Nutrient>? text, int max) {
    StringBuffer buffer = StringBuffer();
    int j = 0;
    for (int i = 0; i < text!.length; i++) {
      j++;
      if (i < text.length - 1) {
        buffer.write("${text[i]},");
      } else {
        buffer.write(text[i]);
      }
      if (j == max) {
        buffer.write("\n");
        j = 0;
      }
    }

    return buffer.toString();
  }
}
