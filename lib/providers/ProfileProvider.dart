import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:craftify/models/ArtisanProfile.dart';
import 'package:craftify/models/User.dart';
import 'package:craftify/services/ProfileService.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProfileProvider with ChangeNotifier {
  ArtisanProfile? _artisanProfile;
  User? _user;

  ArtisanProfile? get artisanProfile => _artisanProfile;
  User? get user => _user;

  Future<void> fetchProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      print("No token found, please login first");
      throw Exception("No token found, please login first");
    }

    final url = 'http://192.168.8.101:8000/api/artisan/profile';
    try {
      print("Fetching profile from $url");
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the profile response
        var data = json.decode(response.body);
        print("Profile data received: $data");

        _artisanProfile = ArtisanProfile.fromJson(data['artisanProfile']);
        _user = User.fromJson(data['user']);
        notifyListeners();
      } else {
        print("Failed to fetch profile, Status code: ${response.statusCode}, Response: ${response.body}");
        throw Exception("Failed to load profile data");
      }
    } catch (e) {
      print("Error occurred while fetching profile: $e");
      throw e;
    }
  }
}


