import 'package:colyak/models/bolusrequest_model.dart';
import 'package:colyak/models/service/api_service.dart';


class BolusController {
  final ApiService _apiService = ApiService();

  Future<void> submitBolusData(Bolus bolus, List<Food> foodList, String token) async {
    BolusRequest bolusRequest = BolusRequest(
      foodList: foodList,
      bolus: bolus,
    );
    await _apiService.addMeal(bolusRequest.toJson(), token);
  }
}
