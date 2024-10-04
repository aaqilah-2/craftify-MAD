import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:craftify/models/CustomerProfile.dart'; // Your customer profile model


class CustomerProfileProvider with ChangeNotifier {
  CustomerProfile? _customerProfile;

  CustomerProfile? get customerProfile => _customerProfile;

  Future<void> fetchCustomerProfile(String token) async {
    final url = 'http://192.168.8.104:8000/api/customer/profile'; // Update with your actual endpoint

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
        notifyListeners(); // Notify the UI to update
      } else {
        print('Failed to load customer profile: ${response.body}');
      }
    } catch (error) {
      print('Error fetching customer profile: $error');
    }
  }
}
