import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  final String baseUrl = 'http://192.168.8.104:8000/api';  // Your API base URL

  // Fetch all approved products
  Future<List<dynamic>> fetchApprovedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];  // Return product list
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Upload a new product
  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      headers: headers,
      body: productData,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload product');
    }
  }

  // Update an existing product
  Future<void> updateProduct(int productId, Map<String, dynamic> updatedData, String token) async {
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.put(
      Uri.parse('$baseUrl/products/$productId'),
      headers: headers,
      body: jsonEncode(updatedData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  // Delete an existing product
  Future<void> deleteProduct(int productId, String token) async {
    final headers = {
      'Authorization': 'Bearer $token',
    };

    final response = await http.delete(
      Uri.parse('$baseUrl/products/$productId'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}
