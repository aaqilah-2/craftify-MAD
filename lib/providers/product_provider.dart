import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  // Fetch products by status for artisan
  Future<void> fetchProductsByStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken'); // Retrieve stored token

    if (token == null) {
      print('Token not found, please login first');
      return;
    }

    final url = 'http://192.168.8.101:8000/api/artisan/products?status=$status';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> productData = json.decode(response.body)['data'];
      _products = productData.map((json) => Product.fromJson(json)).toList();
      notifyListeners(); // Notify listeners to refresh the UI
    } else {
      print('Failed to load products: ${response.body}');
      throw Exception('Failed to load products');
    }
  }

  // Delete product by ID
  Future<void> deleteProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      print('Token not found, please login first');
      return;
    }

    final url = 'http://192.168.8.101:8000/api/products/$productId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      _products.removeWhere((product) => product.id == productId);
      notifyListeners(); // Update UI in real-time after deletion
    } else {
      print('Failed to delete product: ${response.body}');
      throw Exception('Failed to delete product');
    }
  }

  // Update product details
  Future<void> updateProduct(int productId, Map<String, dynamic> updatedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token == null) {
      print('Token not found, please login first');
      return;
    }

    final url = 'http://192.168.8.101:8000/api/products/$productId';
    final response = await http.put(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(updatedData),
    );

    if (response.statusCode == 200) {
      // Update the product in the local list
      final index = _products.indexWhere((product) => product.id == productId);
      if (index != -1) {
        _products[index] = Product.fromJson(json.decode(response.body)['data']);
        notifyListeners();
      }
    } else {
      print('Failed to update product: ${response.body}');
      throw Exception('Failed to update product');
    }
  }
}
