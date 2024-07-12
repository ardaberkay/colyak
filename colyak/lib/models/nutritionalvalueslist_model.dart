class NutritionalValuesList {
  int? id;
  double? unit;
  String? type;
  double? carbohydrateAmount;
  double? proteinAmount;
  double? fatAmount;
  double? calorieAmount;

  NutritionalValuesList(
      {this.id,
      this.unit,
      this.type,
      this.carbohydrateAmount,
      this.proteinAmount,
      this.fatAmount,
      this.calorieAmount});

  factory NutritionalValuesList.fromJson(Map<String, dynamic> json) {
      return NutritionalValuesList(
        id: json['id'],
        unit: json['unit']?.toDouble(),
        type: json['type'],
        carbohydrateAmount: json['carbohydrateAmount']?.toDouble(),
        proteinAmount: json['proteinAmount']?.toDouble(),
        fatAmount: json['fatAmount']?.toDouble(),
        calorieAmount: json['calorieAmount']?.toDouble(),
      );
    }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unit': unit,
      'type': type,
      'carbohydrateAmount': carbohydrateAmount,
      'proteinAmount': proteinAmount,
      'fatAmount': fatAmount,
      'calorieAmount': calorieAmount,
    };
  }
}
