import 'package:flutter/material.dart';
import 'package:colyak/models/addmeallist_model.dart';

class AddMealListController with ChangeNotifier {
  List<AddMealList> meals = [];

  void addMeal(AddMealList meal) {
    meals.add(meal);
    notifyListeners();
  }

  void addOrUpdateMeal(AddMealList meal) {
    final index = meals.indexWhere((m) => m.foodId == meal.foodId && m.type == meal.type);
    if (index != -1) {
      meals[index].amount = (meals[index].amount ?? 0) + meal.amount!;
      meals[index].carbonhydrate = (meals[index].carbonhydrate ?? 0) + meal.carbonhydrate!;
    } else {
      meals.add(meal);
    }
    notifyListeners();
  }

  void incrementAmount(int index) {
    meals[index].amount = (meals[index].amount ?? 0) + 1;
    meals[index].carbonhydrate = (meals[index].carbonhydrate ?? 0) / (meals[index].amount! - 1) * meals[index].amount!;
    notifyListeners();
  }

  void decrementAmount(int index) {
    if (meals[index].amount != null && meals[index].amount! > 1) {
      meals[index].carbonhydrate = (meals[index].carbonhydrate ?? 0) / (meals[index].amount! ) * (meals[index].amount! - 1);
      meals[index].amount = meals[index].amount! - 1;
      notifyListeners();
    }
  }
}
