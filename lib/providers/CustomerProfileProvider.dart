import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/CustomerProfile.dart';

class CustomerProfileProvider with ChangeNotifier {
  CustomerProfile? _customerProfile;

  CustomerProfile? get customerProfile => _customerProfile;

  // Fetch profile function
  Future<void> fetchCustomerProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      print('Token not found. User not logged in.');
      return;
    }

    final url = 'http://192.168.8.104:8000/api/customer/profile';
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final profileData = json.decode(response.body)['data'];
        _customerProfile = CustomerProfile.fromJson(profileData);
        print('Profile fetched successfully: ${response.body}');
        notifyListeners(); // Notify UI to update
      } else {
        print('Failed to load profile: ${response.statusCode}, ${response.body}');
      }
    } catch (error) {
      print('Error fetching profile: $error');
    }
  }



  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://192.168.8.104:8000/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print('Logout successful. Removing token.');
        await prefs.remove('authToken');
        await prefs.remove('userRole');
        notifyListeners(); // Notify app to recheck user state
      } else {
        print('Logout failed. Response: ${response.body}');
      }
    } else {
      print('No token found to log out.');
    }
  }
}
