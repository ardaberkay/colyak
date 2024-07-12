import 'package:colyak/controllers/addmeal_controller.dart';
import 'package:colyak/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colyak/models/addmeallist_model.dart';
import 'package:colyak/models/auth_model.dart';
import 'package:colyak/models/recipejson.dart';
import 'package:colyak/models/service/api_service.dart';

class AddMealPage extends StatefulWidget {
  @override
  _AddMealPageState createState() => _AddMealPageState();
}

class _AddMealPageState extends State<AddMealPage> {
  List<Receipt> allReceipts = [];
  List<Receipt> filteredReceipts = [];
  String? _selectedType;
  int _quantity = 1;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchAllReceipts();
    _searchController.addListener(_filterReceipts);
  }

  Future<void> _fetchAllReceipts() async {
    final authModel = Provider.of<AuthModel>(context, listen: false);
    final apiService = ApiService();
    final receipts = await apiService.getAllReceipts(authModel.token!);
    setState(() {
      allReceipts = receipts;
      filteredReceipts = receipts;
    });
  }

  void _filterReceipts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredReceipts = allReceipts.where((receipt) {
        final receiptName = receipt.receiptName?.toLowerCase() ?? '';
        return receiptName.contains(query);
      }).toList();
    });
  }

  void _showSnackBar(String message, bool success) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: success ? Colors.green : Colors.red,
      duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showReceiptDialog(Receipt receipt) {
    setState(() {
      _selectedType = receipt.nutritionalValuesList?.first.type;
      _quantity = 1; // Reset quantity when opening the dialog
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            var selectedNutritionalValue = receipt.nutritionalValuesList
                ?.firstWhere((value) => value.type == _selectedType);

            void _increaseQuantity() {
              setState(() {
                _quantity++;
              });
            }

            void _decreaseQuantity() {
              setState(() {
                if (_quantity > 1) {
                  _quantity--;
                }
              });
            }

            return AlertDialog(
              backgroundColor: AppColors.secondColor,
              title: Center(
                  child: Text(receipt.receiptName ?? 'No name',
                      style: const TextStyle(color: Colors.white), textAlign: TextAlign.center)),
              content: SizedBox(
                width: 300,
                height: 280,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding:
                          EdgeInsets.symmetric(horizontal: 10.0),
                          filled: true,
                          fillColor: Colors.white),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedType,
                          items: receipt.nutritionalValuesList?.map((value) {
                            return DropdownMenuItem<String>(
                              value: value.type,
                              child: Text('${value.type}'),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          },
                          dropdownColor: AppColors.bgColor,
                        ),
                      ),
                    ),
                    if (selectedNutritionalValue != null) ...[
                      const Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ListTile(
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Protein: ${(selectedNutritionalValue.proteinAmount! * _quantity).toStringAsFixed(1)} g',
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white)),
                            Text(
                                'Karbonhidrat: ${(selectedNutritionalValue.carbohydrateAmount! * _quantity).toStringAsFixed(1)} g',
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white)),
                            Text(
                                'Yağ: ${(selectedNutritionalValue.fatAmount! * _quantity).toStringAsFixed(1)} g',
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white)),
                            Text(
                                'Kalori: ${(selectedNutritionalValue.calorieAmount! * _quantity).toStringAsFixed(1)} kcal',
                                style: const TextStyle(
                                    fontSize: 17, color: Colors.white)),
                          ],
                        ),
                        title: const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Center(
                              child: Text(
                                'Besin Değerleri',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white),
                              )),
                        ),
                      ),
                    ],
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.remove),
                              color: Colors.black,
                              onPressed: _decreaseQuantity,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('$_quantity',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white)),
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.black,
                              onPressed: _increaseQuantity,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1.0, color: Colors.white)),
                      width: 150,
                      child: TextButton(
                        child: const Text(
                          'Öğünü Ekle',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          final addedMeal = AddMealList(
                            foodName: receipt.receiptName,
                            type: _selectedType,
                            foodType: "RECEIPT",
                            foodId: receipt.id,
                            carbonhydrate:
                            selectedNutritionalValue!.carbohydrateAmount! *
                                _quantity,
                            amount: _quantity,
                          );
                          Provider.of<AddMealListController>(context,
                              listen: false)
                              .addOrUpdateMeal(addedMeal);
                          _showSnackBar('Öğün başarıyla eklendi', true);
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(width: 1.0, color: Colors.white)),
                      width: 100,
                      child: TextButton(
                        child: const Text(
                          'Kapat',
                          style: TextStyle(color: Colors.black),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        title: const Text('Öğün Ekle'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Ara...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: AppColors.bgColor,
              child: ListView.builder(
                itemCount: filteredReceipts.length * 2,
                itemBuilder: (context, index) {
                  if (index.isOdd) {
                    return Divider();
                  }
                  final receiptIndex = index ~/ 2;
                  final receipt = filteredReceipts[receiptIndex];
                  return GestureDetector(
                    onTap: () {
                      _showReceiptDialog(receipt);
                    },
                    child: ListTile(
                      title: Text(
                        receipt.receiptName ?? 'No name',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
