import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerProductListingService {
  final String baseUrl = 'http://192.168.8.104:8000/api';  // Replace with your correct API IP

  Future<List<dynamic>> getApprovedProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      print('No token found, user needs to log in.');
      return [];
    }

    final url = Uri.parse('$baseUrl/products?status=approved');
    print('Fetching approved products from $url');

    try {
      final response = await http.get(url, headers: {
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        print('Successfully fetched products');
        return json.decode(response.body)['data'];
      } else {
        print('Failed to fetch products: ${response.body}');
        return [];
      }
    } catch (error) {
      print('Error fetching products: $error');
      return [];
    }
  }
}
