import 'dart:convert';
import 'package:craftify/models/ArtisanProfile.dart';
import 'package:craftify/models/User.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  static Future<Map<String, dynamic>> getProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('auth_token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.get(
      Uri.parse('http://192.168.8.104:8000/api/artisan/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final artisanProfile = ArtisanProfile.fromJson(jsonData['artisanProfile']);
      final user = User.fromJson(jsonData['user']);
      return {
        'artisanProfile': artisanProfile,
        'user': user,
      };
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
