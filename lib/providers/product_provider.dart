import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/models/product.dart';
import 'package:craftify/services/product_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  final ProductService _productService = ProductService(); // Initialize ProductService

  List<Product> get products => _products;

  // Fetch products by status for artisan
  Future<void> fetchProductsByStatus(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken'); // Retrieve stored token

    if (token == null) {
      print('Token not found, please login first');
      return;
    }

    final url = 'http://192.168.8.104:8000/api/artisan/products?status=$status';
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

  // Upload product
  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    try {
      await _productService.uploadProduct(productData);
      await fetchProductsByStatus('approved'); // Refresh after upload
    } catch (e) {
      print('Error uploading product: $e');
      throw e;
    }
  }

  // Update product
  Future<void> updateProduct(int productId, Map<String, dynamic> updatedData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken'); // Ensure token is retrieved

    if (token == null) {
      print('Token not found, please login first');
      return;
    }

    try {
      await _productService.updateProduct(productId, updatedData, token);
      final index = _products.indexWhere((product) => product.id == productId);
      if (index != -1) {
        _products[index] = Product.fromJson(updatedData);
        notifyListeners(); // Notify listeners after update
      }
    } catch (e) {
      print('Error updating product: $e');
      throw e;
    }
  }

  // Delete product
  Future<void> deleteProduct(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken'); // Ensure token is retrieved

    if (token == null) {
      print('Token not found, please login first');
      return;
    }

    try {
      await _productService.deleteProduct(productId, token);
      _products.removeWhere((product) => product.id == productId);
      notifyListeners(); // Notify listeners after deletion
    } catch (e) {
      print('Error deleting product: $e');
      throw e;
    }
  }
}
