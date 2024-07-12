import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colyak/controllers/addmeal_controller.dart';
import 'package:colyak/utils/colors.dart';
import 'package:colyak/views/screens/addmealpage.dart';
import 'package:colyak/views/screens/boluscalculatedpage.dart';
import 'package:colyak/models/auth_model.dart';

class MyMealPage extends StatefulWidget {
  const MyMealPage({super.key});

  @override
  _MyMealPageState createState() => _MyMealPageState();
}

class _MyMealPageState extends State<MyMealPage> {
  double _calculateTotalCarbohydrates(AddMealListController mealProvider) {
    return mealProvider.meals.fold(0.0, (total, meal) => total + (meal.carbonhydrate ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Center(
          child: Text('Çölyak'),
        ),
      ),
      body: Consumer2<AddMealListController, AuthModel>(
        builder: (context, mealProvider, authModel, child) {
          double totalCarbohydrates = _calculateTotalCarbohydrates(mealProvider);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 50.0),
                    child: Text(
                      totalCarbohydrates.toStringAsFixed(1),
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  const Row(
                    children: [
                      Text(
                        'g',
                        style: TextStyle(fontSize: 25),
                      ),
                      Text('/carb'),
                    ],
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BolusCalculatedPage(
                            totalCarbonhydrate: totalCarbohydrates,
                            token: authModel.token!,
                            foodList: mealProvider.meals,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      elevation: 3,
                      fixedSize: const Size(150, 40),
                    ),
                    child: const Text('Bolus Hesapla'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddMealPage()),
                      );
                    },
                    child: Text('Öğün Ekle'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      elevation: 3,
                      fixedSize: const Size(150, 40),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: mealProvider.meals.length,
                  itemBuilder: (context, index) {
                    final meal = mealProvider.meals[index];
                    return Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          mealProvider.meals.removeAt(index);
                          mealProvider.notifyListeners();
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(color: Colors.white12, width: 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        meal.foodName ?? 'No name',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        'Karbonhidrat: ${meal.carbonhydrate?.toStringAsFixed(1)}g',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Tür: ${meal.type}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 20),
                                      onPressed: () {
                                        Provider.of<AddMealListController>(context, listen: false).decrementAmount(index);
                                      },
                                    ),
                                    Text(
                                      '${meal.amount}',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 20),
                                      onPressed: () {
                                        Provider.of<AddMealListController>(context, listen: false).incrementAmount(index);
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
