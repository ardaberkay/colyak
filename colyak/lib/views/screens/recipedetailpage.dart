import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:colyak/models/nutritionalvalueslist_model.dart';

import '../../models/recipejson.dart';

class RecipeDetailPage extends StatelessWidget {
  final Receipt receipt;

  const RecipeDetailPage({required this.receipt, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receipt.receiptName ?? 'Tarif Detayları'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (receipt.imageUrl != null)
                Image.network(receipt.imageUrl!)
              else if (receipt.imageBytes != null)
                Image.memory(receipt.imageBytes!),
              const SizedBox(height: 16),
              Text(
                receipt.receiptName ?? '',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('Oluşturulma Tarihi: ${receipt.createdDate ?? ''}'),
              SizedBox(height: 16),
              const Text(
                'Tarif Detayları',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...?receipt.receiptDetails?.map((detail) => Text(detail)),
              const SizedBox(height: 16),
              const Text(
                'Malzemeler',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              ...?receipt.receiptItems?.map((item) => ListTile(
                    title: Text(item.productName ?? ''),
                    subtitle: Text('${item.unit} ${item.type}'),
                  )),
              SizedBox(height: 16),
              const Text(
                'Besin Değerleri',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              ...?receipt.nutritionalValuesList?.map((value) => ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${value.proteinAmount} gr protein'),
                        Text('${value.carbohydrateAmount} gr karbonhidrat'),
                        Text('${value.fatAmount} gr yağ'),
                        Text('${value.calorieAmount} kalori'),
                      ],
                    ),
                    title: Text('${value.type} '),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
