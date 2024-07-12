class MealReport {
  final String userName;
  final List<FoodResponse> foodResponseList;
  final Bolus bolus;
  final String dateTime;

  MealReport({
    required this.userName,
    required this.foodResponseList,
    required this.bolus,
    required this.dateTime,
  });

  factory MealReport.fromJson(Map<String, dynamic> json) {
    return MealReport(
      userName: json['userName'],
      foodResponseList: (json['foodResponseList'] as List)
          .map((i) => FoodResponse.fromJson(i))
          .toList(),
      bolus: Bolus.fromJson(json['bolus']),
      dateTime: json['dateTime'],
    );
  }
}

class FoodResponse {
  final String foodType;
  final double carbonhydrate;
  final String foodName;

  FoodResponse({
    required this.foodType,
    required this.carbonhydrate,
    required this.foodName,
  });

  factory FoodResponse.fromJson(Map<String, dynamic> json) {
    return FoodResponse(
      foodType: json['foodType'],
      carbonhydrate: json['carbonhydrate'],
      foodName: json['foodName'],
    );
  }
}

class Bolus {
  final int id;
  final int bloodSugar;
  final int targetBloodSugar;
  final int insulinTolerateFactor;
  final int totalCarbonhydrate;
  final int insulinCarbonhydrateRatio;
  final int bolusValue;
  final String eatingTime;

  Bolus({
    required this.id,
    required this.bloodSugar,
    required this.targetBloodSugar,
    required this.insulinTolerateFactor,
    required this.totalCarbonhydrate,
    required this.insulinCarbonhydrateRatio,
    required this.bolusValue,
    required this.eatingTime,
  });

  factory Bolus.fromJson(Map<String, dynamic> json) {
    return Bolus(
      id: json['id'],
      bloodSugar: json['bloodSugar'],
      targetBloodSugar: json['targetBloodSugar'],
      insulinTolerateFactor: json['insulinTolerateFactor'],
      totalCarbonhydrate: json['totalCarbonhydrate'],
      insulinCarbonhydrateRatio: json['insulinCarbonhydrateRatio'],
      bolusValue: json['bolusValue'],
      eatingTime: json['eatingTime'],
    );
  }
}
