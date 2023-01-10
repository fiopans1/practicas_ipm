import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:recipes_app/edamam.dart';
import 'package:stack/stack.dart' as Stack1;

class VariablesProvider extends ChangeNotifier {
  List<Recipe> gList = [];
  String search = "";
  String diet = "balanced";
  RecipeBlock block = RecipeBlock(from: 0, to: 0, count: 0);
  var stack = Stack1.Stack<String>();
  var temp = "";
  bool error = false;
  bool spinner = false;
  List<String> msgError = ["msg1", "msg2"];
  bool readError() {
    var error2 = this.error;
    this.error = false;
    return error2;
  }

  List<String> getMsgError8() {
    List<String> msg = msgError;
    msgError = ["msg1", "msg2"];
    return msg;
  }

  void setGList(List<Recipe> list) {
    this.gList = list;
    notifyListeners();
  }

  void setSearch(String search) {
    this.search = search;
  }

  void setSearchAndDiet() {
    updateList(this.search.toLowerCase(), this.diet, "", 0);
  }

  void updateList(String search, String diet, String next, int next1) async {
    spinner = true;
    notifyListeners();
    if (block.actualBlock != "" && next1 == 1) {
      stack.push(block.actualBlock.toString());
    }
    if (next1 == 0) {
      for (int i = 0; i < stack.size(); i++) {
        if (stack.isNotEmpty) {
          stack.pop();
        }
      }
    }
    try {
      var valor = await search_recipes(search, diet, next, next1);
      //a esta linea meterle un try catch
      block = valor!;
      if (next1 == -1) {
        block.actualBlock = temp;
      }
      List<Recipe> list = valor.recipes!.toList();
      gList = [];
      gList.addAll(list);
      spinner = false;
      notifyListeners();
    } catch (e) {
      String error = e.toString();
      if (error == "FormatException: [No hay siguiente]") {
        if (next1 == 1) {
          stack.pop();
        }
        this.error = true;
        if (next1 == 1) {
          this.msgError = ["WARNING", "No next block"];
        } else {
          this.msgError = ["WARNING", "No results for this search"];
          gList = [];
        }
        spinner = false;
        notifyListeners();
      } else {
        if (error == "Null check operator used on a null value") {
          this.error = true;
          this.msgError = ["WARNING", "No results for this search"];
        } else {
          this.error = true;
          this.msgError = [
            "AN ERROR HAS OCURRED",
            "Check your connection\n or maybe you reached adamam limit"
          ];
        }
        for (int i = 0; i < stack.size(); i++) {
          if (stack.isNotEmpty) {
            stack.pop();
          }
        }
        spinner = false;
        gList = [];
        notifyListeners();
      }
    }
  }

  void loadNext() {
    if (block.nextBlock != null) {
      updateList(search, diet, block.nextBlock.toString(), 1);
    } else {
      this.error = true;
      this.msgError = ["WARNING", "No next block"];
      notifyListeners();
    }
  }

  void loadPrev() {
    if (block.from == 0 || block.from == 1) {
      this.error = true;
      this.msgError = ["WARNING", "No previous block"];
      notifyListeners();
    } else {
      if (stack.isNotEmpty) {
        this.temp = stack.pop();
        updateList(search, diet, this.temp, -1);
      } else if (stack.isEmpty) {
        updateList(search, diet, "", 0);
      }
    }
  }

  void setDiet(String diet) {
    this.diet = diet;
    notifyListeners();
  }
}

class VariablesTablet extends ChangeNotifier {
  Recipe data = new Recipe();
  void setRecipe(Recipe data) {
    this.data = data;
    notifyListeners();
  }

  bool isNull() {
    return (data.label == null);
  }
}

class VariablesInfo extends ChangeNotifier {
  List<bool> items = [false, false, false, false, false, false];
  void setRecipe(bool item, int i) {
    this.items[i] = item;
    notifyListeners();
  }

  void changeExpanded(bool change, int i) {
    this.items[i] = change;
    notifyListeners();
  }
}
