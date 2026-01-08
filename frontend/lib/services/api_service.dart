import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/transaction.dart';

class ApiService {
  // Updated for Codespaces
  static const String baseUrl = 'https://cautious-zebra-x5gjvr76r4vc9975-8080.app.github.dev/api';

  // User APIs
  Future<User?> register(String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Register error: $e');
    }
    return null;
  }

  Future<User?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return User.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Login error: $e');
    }
    return null;
  }

  // Transaction APIs
  Future<Transaction?> addTransaction(Transaction transaction) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(transaction.toJson()),
      );

      if (response.statusCode == 200) {
        return Transaction.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Add transaction error: $e');
    }
    return null;
  }

  Future<List<Transaction>> getTransactions(int userId, {String? month}) async {
    try {
      String url = '$baseUrl/transactions?userId=$userId';
      if (month != null) {
        url += '&month=$month';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Transaction.fromJson(json)).toList();
      }
    } catch (e) {
      print('Get transactions error: $e');
    }
    return [];
  }
}
