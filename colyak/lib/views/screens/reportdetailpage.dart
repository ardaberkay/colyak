import 'package:colyak/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:colyak/models/meals_report.dart';
import 'package:intl/intl.dart';

class ReportDetailPage extends StatefulWidget {
  final MealReport mealReport;

  const ReportDetailPage({Key? key, required this.mealReport}) : super(key: key);

  @override
  _ReportDetailPageState createState() => _ReportDetailPageState();
}

class _ReportDetailPageState extends State<ReportDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rapor Detayı'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Card(
              elevation: 4,
              child: ListTile(
                title: Text('Kullanıcı: ${widget.mealReport.userName}', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Tarih: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.mealReport.dateTime))}'),
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: AppColors.bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bolus Bilgisi:',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.mainColor),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Kan Şekeri: ${widget.mealReport.bolus.bloodSugar}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Hedef Kan Şekeri: ${widget.mealReport.bolus.targetBloodSugar}',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'İnsülin Tolerans Faktörü: ${widget.mealReport.bolus.insulinTolerateFactor}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Toplam Karbonhidrat: ${widget.mealReport.bolus.totalCarbonhydrate}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'İnsülin-Karbonhidrat Oranı: ${widget.mealReport.bolus.insulinCarbonhydrateRatio}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Yeme Zamanı: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.parse(widget.mealReport.bolus.eatingTime))}',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Bolus: ${widget.mealReport.bolus.bolusValue}',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Text('Öğünler:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.mealReport.foodResponseList.map((food) => Card(
              elevation: 2,
              child: ListTile(
                title: Text(food.foodName),
                subtitle: Text('Karbonhidrat: ${food.carbonhydrate}'),
                leading: Icon(Icons.fastfood, color: AppColors.mainColor),
              ),
            )),
          ],
        ),
      ),
    );
  }
}