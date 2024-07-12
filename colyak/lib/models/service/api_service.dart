import 'dart:convert';
import 'package:colyak/models/bolusrequest_model.dart';
import 'package:colyak/models/recipejson.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../meals_report.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api.colyakdiyabet.com.tr/api'));

  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post('/users/verify/login', data: {
        'email': email,
        'password': password,
      });
      print('Login response data: ${response.data}');
      return response;
    } catch (e) {
      print('Login API exception: $e');
      rethrow;
    }
  }

  Future<Response> signup(String email, String password, String name) async {
    try {
      final response = await _dio.post('/users/verify/create', data: {
        'email': email,
        'password': password,
        'name': name,
        'role': ['User'],
        'comments': [],
        'likes': [],
        'replies': [],
        'suggestions': [],
        'meals': [],
        'userAnswers': []
      });
      print('Signup response data: ${response.data}');
      return response;
    } catch (e) {
      print('Signup API exception: $e');
      rethrow;
    }
  }

  Future<Response> logout(String token) async {
    try {
      final response = await _dio.post(
        '/users/verify/logout',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      print('Logout response data: ${response.data}');
      return response;
    } catch (e) {
      if (e is DioError) {
        print('Logout API exception: ${e.response?.data}');
      } else {
        print('Logout API exception: $e');
      }
      rethrow;
    }
  }

  Future<Response> refreshToken(String refreshToken) async {
    try {
      final response = await _dio.post('/users/verify/refresh-token', data: {
        'refresh_token': refreshToken,
      });
      print('Refresh token response data: ${response.data}');
      return response;
    } catch (e) {
      print('Refresh token API exception: $e');
      if (e is DioException && e.response != null) {
        print('Dio exception response data: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<Response> verifyEmail(String verificationId, String oneTimeCode) async {
    try {
      final response = await _dio.post('/users/verify/verify-email', data: {
        'verificationId': verificationId,
        'oneTimeCode': oneTimeCode,
      });
      print('Verify email response data: ${response.data}');
      return response;
    } catch (e) {
      print('Verify email API exception: $e');
      if (e is DioException && e.response != null) {
        print('Dio exception response data: ${e.response?.data}');
      }
      rethrow;
    }
  }


  Future<List<Receipt>> getTop5Receipts(String token) async {
    try {
      final response = await _dio.get('/meals/report/top5receipts', options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Receipt.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load top 5 receipts');
      }
    } catch (e) {
      print('Top 5 Receipts API exception: $e');
      rethrow;
    }
  }

  Future<List<Receipt>> getAllReceipts(String token) async {
    try {
      final response = await _dio.get('/receipts/getAll/all', options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Receipt.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load all receipts');
      }
    } catch (e) {
      print('All Receipts API exception: $e');
      rethrow;
    }
  }

  Future<String> getImage(String imageId) async {
    try {
      final response = await _dio.get('/image/get/$imageId');
      if (response.statusCode == 200) {
        return response.data.toString();

      } else {
        throw Exception('Failed to load image');
      }
    } catch (e) {
      print('Image API exception: $e');
      rethrow;
    }
  }

  Future<Response> addMeal(Map<String, dynamic> mealData, String token) async {
    try {
      final response = await _dio.post(
        '/meals/add',
        data: mealData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint('Add meal response data: ${response.data}');
      return response;
    } catch (e) {
      if (e is DioError) {
        print('Add meal API exception: ${e.response?.data}');
      }
      rethrow;
    }
  }

  Future<void> postBolusData(BolusRequest data, String token) async {
    final url = '/meals/add';
    try {
      final response = await _dio.post(
        url,
        data: json.encode(data),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        // Handle success
        print('Success');
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioError) {
        print('Post Bolus API exception: ${e.response?.data}'); // Hata mesajını daha ayrıntılı loglayalım
      }
      rethrow;
    }
  }

  Future<List<MealReport>> getMealReport(String email, String startDate, String endDate, String token) async {
    try {
      final response = await _dio.get(
        '/meals/report/$email/$startDate/$endDate',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        debugPrint('Data: ${data.toString()}');
        return data.map((json) => MealReport.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load meal report');
      }
    } catch (e) {
      debugPrint('Get Meal Report API exception: $e');
      rethrow;
    }
  }




}
