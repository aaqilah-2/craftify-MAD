import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:craftify/models/ArtisanProfile.dart';
import 'package:craftify/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileProvider with ChangeNotifier {
  ArtisanProfile? _artisanProfile;
  User? _user;

  // Getter for ArtisanProfile and User
  ArtisanProfile? get artisanProfile => _artisanProfile;
  User? get user => _user;

  // Method to set the ArtisanProfile
  void setArtisanProfile(ArtisanProfile profile) {
    _artisanProfile = profile;
    notifyListeners(); // Notify listeners to update UI
  }

  // Method to set the User profile
  void setUserProfile(User user) {
    _user = user;
    notifyListeners(); // Notify listeners to update UI
  }



  // Method to fetch the profile data
  Future<void> fetchProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token'); // Fetch the auth token

    if (token == null) {
      print("No token found, please login first");
      throw Exception("No token found, please login first");
    }

    // API Endpoint
    final url = 'http://192.168.8.101:8000/api/artisan/profile';
    print("Fetching profile from $url");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token', // Pass the token in the request header
        'Content-Type': 'application/json',
      },
    );

    // Check for successful response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Profile data received: $data");

      // Parse the ArtisanProfile and User from the response data
      setArtisanProfile(ArtisanProfile.fromJson(data['artisanProfile']));
      setUserProfile(User.fromJson(data['user']));

      // Notify listeners to rebuild the UI after data is fetched
      notifyListeners();
    } else {
      print("Failed to fetch profile, Status code: ${response.statusCode}, Response: ${response.body}");
      throw Exception("Failed to load profile data");
    }
  }


}
