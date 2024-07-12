import 'package:flutter/material.dart';

class AuthModel with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  String? _email;
  String? _userName; // Kullanıcı adı için bir alan ekleyin

  String? get token => _token;
  String? get email => _email;
  String? get userName => _userName; // Kullanıcı adını döndüren getter
  String? get refreshToken => _refreshToken;

  bool get isAuthenticated => _token != null;

  void setToken(String token, String refreshToken, String email, String userName) {
    _token = token;
    _refreshToken = refreshToken;
    _email = email;
    _userName = userName; // Kullanıcı adını burada ayarlayın
    notifyListeners();
  }

  void clearToken() {
    _token = null;
    _refreshToken = null;
    _email = null;
    _userName = null; // Kullanıcı adını temizleyin
    notifyListeners();
  }
}
