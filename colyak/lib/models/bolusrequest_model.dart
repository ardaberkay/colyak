class BolusRequest {
  final List<Food> foodList;
  final Bolus bolus;

  BolusRequest({required this.foodList, required this.bolus});

  Map<String, dynamic> toJson() {
    return {
      'foodList': foodList.map((food) => food.toJson()).toList(),
      'bolus': bolus.toJson(),
    };
  }
}

class Bolus {
  int bloodSugar;
  int targetBloodSugar;
  int insulinTolerateFactor;
  double totalCarbonhydrate;
  int insulinCarbonhydrateRatio;
  int bolusValue;
  String eatingTime;

  Bolus({
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
      bloodSugar: json['bloodSugar'],
      targetBloodSugar: json['targetBloodSugar'],
      insulinTolerateFactor: json['insulinTolerateFactor'],
      totalCarbonhydrate: json['totalCarbonhydrate'].toDouble(),
      insulinCarbonhydrateRatio: json['insulinCarbonhydrateRatio'],
      bolusValue: json['bolusValue'],
      eatingTime: json['eatingTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "bloodSugar": bloodSugar,
      "targetBloodSugar": targetBloodSugar,
      "insulinTolerateFactor": insulinTolerateFactor,
      "totalCarbonhydrate": totalCarbonhydrate,
      "insulinCarbonhydrateRatio": insulinCarbonhydrateRatio,
      "bolusValue": bolusValue,
      "eatingTime": eatingTime,
    };
  }
}

class Food {
  String foodType;
  int foodId;
  double carbonhydrate;

  Food({
    required this.foodType,
    required this.foodId,
    required this.carbonhydrate,
  });

  Map<String, dynamic> toJson() {
    return {
      "foodType": foodType,
      "foodId": foodId,
      "carbonhydrate": carbonhydrate,
    };
  }
}

class UserResponse {
  String userName;
  List<FoodResponse> foodResponseList;
  Bolus bolus;
  DateTime dateTime;

  UserResponse({
    required this.userName,
    required this.foodResponseList,
    required this.bolus,
    required this.dateTime,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userName: json['userName'],
      foodResponseList: (json['foodResponseList'] as List)
          .map((i) => FoodResponse.fromJson(i))
          .toList(),
      bolus: Bolus.fromJson(json['bolus']),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'foodResponseList': foodResponseList.map((e) => e.toJson()).toList(),
      'bolus': bolus.toJson(),
      'dateTime': dateTime.toIso8601String(),
    };
  }
}

class FoodResponse {
  String foodType;
  int carbonhydrate;
  String foodName;

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

  Map<String, dynamic> toJson() {
    return {
      'foodType': foodType,
      'carbonhydrate': carbonhydrate,
      'foodName': foodName,
    };
  }
}


