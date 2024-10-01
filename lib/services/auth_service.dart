import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Define the API base URL
  static const String apiUrl = 'http://192.168.8.101:8000/api';

  // Login method
  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$apiUrl/user/auth');

    try {
      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password}),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Store the token in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);

        return responseData;
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Registration method
  Future<Map<String, dynamic>> register(Map<String, dynamic> data) async {
    final url = Uri.parse('$apiUrl/user/auth');

    try {
      final response = await http.post(
        url,
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Store the token in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);

        return responseData;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Fetch user profile method
  Future<Map<String, dynamic>> getUserProfile() async {
    final url = Uri.parse('$apiUrl/user');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    try {
      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch user profile');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Logout method
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token
  }
}
