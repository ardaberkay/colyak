import 'package:colyak/models/service/api_service.dart';
import 'package:colyak/views/screens/verifyemailpage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';
import 'package:dio/dio.dart';
import '../views/screens/loginpage.dart';

class AuthController {
  final ApiService _apiService = ApiService();

  Future<bool> login(BuildContext context, String email, String password) async {
    try {
      final response = await _apiService.login(email, password);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final token = data['token'];
        final refreshToken = data['refreshToken'];
        final userEmail = data['email'];
        final userName = data['userName'];

        if (token != null && refreshToken != null) {
          Provider.of<AuthModel>(context, listen: false).setToken(token, refreshToken, userEmail, userName);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          await prefs.setString('refreshToken', refreshToken);

          return true;
        } else {
          print('Login failed: token or refreshToken is null');
          return false;
        }
      } else {
        print('Login failed with status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Login exception: $e');
      if (e is DioException && e.response != null) {
        print('Dio exception response data: ${e.response?.data}');
      }
      return false;
    }
  }


  Future<bool> signup(BuildContext context, String email, String password, String name) async {
    try {
      final response = await _apiService.signup(email, password, name);

      if (response.statusCode == 201) {
        final verificationId = response.data;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Kayıt başarılı! Lütfen e-postanızı doğrulayın.'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailPage(verificationId: verificationId),
          ),
        );
        return true;
      } else {
        print('Signup failed with status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Signup exception: $e');
      if (e is DioException && e.response?.data != null) {
        String errorMessage;
        print('Response data type: ${e.response?.data.runtimeType}');
        if (e.response?.data is Map) {
          errorMessage = (e.response?.data['message'] ?? 'Kayıt işlemi başarısız oldu.') as String;
        } else if (e.response?.data is String) {
          errorMessage = e.response?.data;
        } else {
          errorMessage = 'Kayıt işlemi başarısız oldu.';
        }

        print('Parsed error message: $errorMessage');

        if (errorMessage.contains('already exists')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Bu e-posta adresi zaten kullanılıyor.'),
              duration: Duration(seconds: 3),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
      return false;
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token != null) {
      try {
        final response = await _apiService.logout(token);

        if (response.statusCode == 200) {
          Provider.of<AuthModel>(context, listen: false).clearToken();
          await prefs.clear();

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
          );
        } else {
          print('Logout failed with status code: ${response.statusCode}');
          print('Response data: ${response.data}');
        }
      } catch (e) {
        if (e is DioError) {
          print('Logout API exception: ${e.response?.data}');
        } else {
          print('Logout exception: $e');
        }
      }
    } else {
      print('Token is null');
    }
  }



  Future<bool> verifyEmail(BuildContext context, String verificationId, String oneTimeCode) async {
    try {
      final response = await _apiService.verifyEmail(verificationId, oneTimeCode);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('E-posta doğrulandı!'),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
        return true;
      } else {
        print('Verify email failed with status code: ${response.statusCode}');
        print('Response data: ${response.data}');
        return false;
      }
    } catch (e) {
      print('Verify email exception: $e');
      return false;
    }
  }
}
