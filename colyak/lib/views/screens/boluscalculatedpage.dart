import 'package:colyak/controllers/bolus_controller.dart';
import 'package:colyak/models/addmeallist_model.dart';
import 'package:colyak/models/bolusrequest_model.dart';
import 'package:colyak/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BolusCalculatedPage extends StatefulWidget {
  final double totalCarbonhydrate;
  final String token;
  final List<AddMealList> foodList;

  const BolusCalculatedPage({super.key, required this.totalCarbonhydrate, required this.token, required this.foodList});

  @override
  State<BolusCalculatedPage> createState() => _BolusCalculatedPageState();
}

class _BolusCalculatedPageState extends State<BolusCalculatedPage> {
  TextEditingController bloodSugarController = TextEditingController();
  TextEditingController targetBloodSugarController = TextEditingController();
  TextEditingController insulinTolerateFactorController = TextEditingController();
  TextEditingController insulinCarbonhydrateRatioController = TextEditingController();
  TextEditingController totalCarbonhydrateController = TextEditingController();
  DateTime? eatingTime;
  double bolusValue = 0.0;

  final BolusController _bolusController = BolusController();

  @override
  void initState() {
    super.initState();
    totalCarbonhydrateController.text = widget.totalCarbonhydrate.toStringAsFixed(1); // initial value
  }

  void calculateBolus() {
    double totalCarbonhydrate = double.parse(totalCarbonhydrateController.text);
    int insulinCarbonhydrateRatio = int.parse(insulinCarbonhydrateRatioController.text);
    int bloodSugar = int.parse(bloodSugarController.text);
    int targetBloodSugar = int.parse(targetBloodSugarController.text);
    int insulinTolerateFactor = int.parse(insulinTolerateFactorController.text);
    setState(() {
      bolusValue = ((totalCarbonhydrate / insulinCarbonhydrateRatio) +
          (bloodSugar - targetBloodSugar)) /
          insulinTolerateFactor;
    });
  }

  Future<void> submitData() async {
    if (bloodSugarController.text.isEmpty ||
        targetBloodSugarController.text.isEmpty ||
        insulinTolerateFactorController.text.isEmpty ||
        insulinCarbonhydrateRatioController.text.isEmpty ||
        totalCarbonhydrateController.text.isEmpty ||
        eatingTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lütfen tüm alanları doldurun!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    calculateBolus();
    Bolus bolus = Bolus(
      bloodSugar: int.parse(bloodSugarController.text),
      targetBloodSugar: int.parse(targetBloodSugarController.text),
      insulinTolerateFactor: int.parse(insulinTolerateFactorController.text),
      totalCarbonhydrate: double.parse(totalCarbonhydrateController.text),
      insulinCarbonhydrateRatio: int.parse(insulinCarbonhydrateRatioController.text),
      bolusValue: bolusValue.toInt(),
      eatingTime: DateFormat("yyyy-MM-ddTHH:mm:ss").format(eatingTime!), // Kullanıcının seçtiği zaman
    );

    List<Food> foodList = widget.foodList.map((meal) => Food(
      foodType: meal.foodType!,
      foodId: meal.foodId!,
      carbonhydrate: meal.carbonhydrate!,
    )).toList();

    await _bolusController.submitBolusData(bolus, foodList, widget.token);

    // Show bolus value in a dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.secondColor,
          title: const Text('Bolus Hesaplama Sonucu', style: const TextStyle(color: Colors.white), textAlign: TextAlign.center),
          content: Text('İnsülin Dozu: ${bolusValue.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white, fontSize: 16)),
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(width: 1.0, color: Colors.white)),
              child: Center(
                child: TextButton(
                  child: const Text('Tamam', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (date != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      );

      if (time != null) {
        setState(() {
          eatingTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Bolus Hesaplama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: bloodSugarController,
              decoration: InputDecoration(labelText: 'Kan Şekeri'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: targetBloodSugarController,
              decoration: InputDecoration(labelText: 'Hedef Kan Şekeri'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: insulinTolerateFactorController,
              decoration: InputDecoration(labelText: 'İnsülün Duyarlılık Faktörü'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: insulinCarbonhydrateRatioController,
              decoration: InputDecoration(labelText: 'İnsülin Karbonhidrat Oranı'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: totalCarbonhydrateController,
              decoration: InputDecoration(labelText: 'Toplam Karbonhidrat'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDateTime(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Buton boyutu
                    textStyle: TextStyle(fontSize: 17), // Yazı stili
                  ),
                  child: Text(eatingTime == null
                      ? 'Yemek Zamanını Seçin'
                      : 'Seçildi: ${DateFormat('yyyy-MM-dd HH:mm').format(eatingTime!)}'),
                ),
                ElevatedButton(
                  onPressed: submitData,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Buton boyutu
                    textStyle: TextStyle(fontSize: 17), // Yazı stili
                  ),
                  child: Text('Gönder'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
