import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {

  // Define the API base URL
  static const String apiUrl = 'http://192.168.8.104:8000/api';  // Ensure it is formatted properly with "http"

  // New method to fetch user details (after login)
  Future<void> fetchUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');  // Ensure correct token field is used

    if (token != null) {
      final response = await http.get(
        Uri.parse('$apiUrl/user/auth'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);

        // Store user details in SharedPreferences
        prefs.setInt('userId', userData['id']);
        prefs.setString('userName', userData['name']);
        prefs.setInt('userRole', userData['role']);
        print('User ID stored: ${userData['id']}');
      } else {
        print('Failed to fetch user details: ${response.body}');
      }
    } else {
      print('No token found');
    }
  }

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
        await prefs.setString('authToken', responseData['token']); // Store token as 'authToken'

        // Fetch and store user details after login
        await fetchUserDetails();

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
        await prefs.setString('authToken', responseData['token']); // Store token as 'authToken'

        // Fetch and store user details after registration
        await fetchUserDetails();

        return responseData;
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  // Fetch user profile method (when needed)
  Future<Map<String, dynamic>> getUserProfile() async {
    final url = Uri.parse('$apiUrl/user');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');  // Make sure 'authToken' is used consistently

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

  // Logout method (clear token and user details)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Remove the token
    await prefs.remove('userId'); // Remove user ID
    await prefs.remove('userName'); // Remove user name
    await prefs.remove('userRole'); // Remove user role
    print('User logged out and data cleared.');
  }
}
