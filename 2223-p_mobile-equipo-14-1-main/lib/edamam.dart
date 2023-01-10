import 'dart:convert';
import 'dart:core';

import 'package:http/http.dart' as http;

const API_URL = "api.edamam.com";
const ENDPOINT = "api/recipes/v2";
const TYPE = "public";
const APP_ID = "3f345ea9";
const APP_KEY = "30fed8bf6abd6157ff25d241c689b047";

class Nutrient {
  Map<String, String> units = {
    "Energy": "kcal",
    "Fat": "g",
    "Saturated": "g",
    "Trans": "g",
    "Monounsaturated": "g",
    "Polyunsaturated": "g",
    "Carbs": "g",
    "Carbohydrates (net)": "g",
    "Fiber": "g",
    "Sugars": "g",
    "Sugars, added": "g",
    "Protein": "g",
    "Cholesterol": "g",
    "Sodium": "mg",
    "Calcium": "mg",
    "Magnesium": "mg",
    "Potassium": "mg",
    "Iron": "mg",
    "Zinc": "mg",
    "Phosphorus": "mg",
    "Vitamin A": "µg",
    "Vitamin C": "mg",
    "Thiamin (B1)": "mg",
    "Riboflavin (B2)": "mg",
    "Niacin (B3)": "mg",
    "Vitamin B6": "mg",
    "Folate equivalent (total)": "µg",
    "Folate (food)": "µg",
    "Folic acid": "µg",
    "Vitamin B12": "µg",
    "Vitamin D": "µg",
    "Vitamin E": "mg",
    "Vitamin K": "µg",
    "Sugar alcohol": "g",
    "Water": "g"
  };
  String label;
  double value;
  Nutrient(this.label, this.value);
  @override
  String toString() {
    return "\n\t$label: ${value.toStringAsFixed(2)} ${units[label]}";
  }
}

class Recipe {
  String? uri;
  String? label;
  String? image;
  String? thumbnail;
  String? source;
  String? sourceUrl;
  double? servings;
  List<String>? healthLabels;
  List<String>? dietLabels;
  List<String>? cautions;
  List<String>? ingredients;
  double? calories;
  double? glycemicIndex;
  double? totalCO2Emissions;
  String? co2EmissionsClass;
  double? totalTime;
  List<String>? cuisineType;
  List<String>? mealType;
  List<String>? dishType;
  List<Nutrient>? totalNutrients;
  List<Nutrient>? totalDaily;

  Recipe(
      //datos que nos devuelve la aplicacion
      {this.uri,
      this.label,
      this.image,
      this.thumbnail,
      this.source,
      this.sourceUrl,
      this.servings,
      this.healthLabels,
      this.dietLabels,
      this.cautions,
      this.ingredients,
      this.calories,
      this.glycemicIndex,
      this.totalCO2Emissions,
      this.co2EmissionsClass,
      this.totalTime,
      this.cuisineType,
      this.mealType,
      this.dishType,
      this.totalNutrients,
      this.totalDaily});

  @override
  String toString() {
    return "Recipe: \n" +
        "\tUri: $uri\n" +
        "\tLabel: $label\n" +
        "\tSource: $source\n" +
        "\tSourceUrl: $sourceUrl\n" +
        "\tServings: $servings\n" +
        "\tHealthLabels: $healthLabels\n" +
        "\tDietLabels: $dietLabels\n" +
        "\tCautions: $cautions\n" +
        "\tIngredients: $ingredients\n" +
        "\tCalories: $calories\n" +
        "\tGlycemicIndex: $glycemicIndex\n" +
        "\tTotalCO2Emissions: $totalCO2Emissions\n" +
        "\tCo2EmissionsClass: $co2EmissionsClass\n" +
        "\tTotalTime: $totalTime\n" +
        "\tCuisineType: $cuisineType\n" +
        "\tMealType: $mealType\n" +
        "\tDishType: $dishType\n" +
        "\tTotalNutrients: \n$totalNutrients\n" +
        "\tTotalDaily: \n$totalDaily\n";
  }
}

class RecipeBlock {
  //bloque con las recetas
  int from;
  int to;
  int count;
  String? nextBlock;
  String? actualBlock;
  List<Recipe>? recipes;

  RecipeBlock(
      {required this.from,
      required this.to,
      required this.count,
      this.actualBlock,
      this.nextBlock,
      this.recipes});

  @override
  String toString() {
    return "RecipeBlock: From: $from | To: $to | Count: $count\n" +
        "$recipes\n" +
        "NextBlock: $nextBlock";
  }
}

class FormatException implements Exception {
  final List<String> msg;
  const FormatException(this.msg);
  @override
  String toString() => "FormatException: $msg";
}

List<String>? parse_list(var list) =>
    list != null ? List<String>.from(list) : null;

Future<RecipeBlock?> search_recipes(
    String query, String diet, String next, int next1) async {
  //el query es la consulta y el range es el rango de calorias
  // TODO: include a search criteria!
  //sería añadir un if en el uri para elegir el bloque
  var formattedQuery = (next1 != 0)
      ? "type=$TYPE&beta=true&app_id=$APP_ID&app_key=$APP_KEY&q=$query&diet=$diet&_cont=$next"
      : "type=$TYPE&beta=true&app_id=$APP_ID&app_key=$APP_KEY&q=$query&diet=$diet"; //añadimos el rango de calorias a la query, esa es nuestra consulta

  var uri = Uri(
      scheme: "https", host: API_URL, path: ENDPOINT, query: formattedQuery);

  var response = await http.get(uri);
  var data = jsonDecode(response.body);

  if (response.statusCode != 200) {
    List<String> errors = [];
    if (data is List) {
      for (var element in data) {
        errors.add("${element["message"]} ${element["params"]}");
      }
    } else {
      errors.add("${data["message"]} ${data["params"]}");
    }
    throw FormatException(errors);
  }

  RecipeBlock block;

  if (data['count'] == 0) {
    block = RecipeBlock(from: 0, to: 0, count: 0);
  } else {
    List<Recipe> recipes = [];

    for (var hit in data["hits"]) {
      var recipe = hit["recipe"];
      List<Nutrient> totalNutrients = [];
      recipe["totalNutrients"]?.forEach((key, value) {
        totalNutrients.add(Nutrient(value["label"], value["quantity"]));
      });

      List<Nutrient> totalDaily = [];
      recipe["totalDaily"]?.forEach((key, value) {
        totalDaily.add(Nutrient(value["label"], value["quantity"]));
      });

      recipes.add(Recipe(
          uri: recipe["uri"],
          label: recipe["label"],
          image: recipe["image"],
          thumbnail: recipe["images"]["THUMBNAIL"]["url"],
          source: recipe["source"],
          sourceUrl: recipe["url"],
          servings: recipe["yield"],
          dietLabels: parse_list(recipe["dietLabels"]),
          healthLabels: parse_list(recipe["healthLabels"]),
          cautions: parse_list(recipe["cautions"]),
          ingredients: parse_list(recipe["ingredientLines"]),
          calories: recipe["calories"],
          glycemicIndex: recipe["glycemicIndex"],
          totalCO2Emissions: recipe["totalCO2Emissions"],
          co2EmissionsClass: recipe["co2EmissionsClass"],
          totalTime: recipe["totalTime"],
          cuisineType: parse_list(recipe["cuisineType"]),
          mealType: parse_list(recipe["mealType"]),
          dishType: parse_list(recipe["dishType"]),
          totalNutrients: totalNutrients,
          totalDaily: totalDaily));
    }
    try {
      String consulta = data["_links"]["next"]["href"];
      var partido = consulta.split("_cont=");
      var consulta2 = partido[1];
      var partido2 = consulta2.split("&diet");
      String next2 = partido2[0];
      block = RecipeBlock(
          from: data["from"],
          to: data["to"],
          count: data["count"],
          actualBlock: (next1 == 1) ? next : "",
          nextBlock: next2,
          recipes: recipes);
    } catch (e) {
      throw FormatException(["No hay siguiente"]);
    }
  }
  return block;
}

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print("Usage: dart edamam.dart search_string");
  } else {
    try {
      var block = await search_recipes(arguments[0], arguments[1], "null", 0);
      print(block);
    } catch (exception) {
      print(exception);
    }
  }
}
