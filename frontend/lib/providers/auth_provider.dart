import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  final ApiService _apiService = ApiService();

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  Future<bool> register(String name, String email, String password) async {
    final user = await _apiService.register(name, email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    final user = await _apiService.login(email, password);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
