import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductService {
  final String baseUrl = 'http://192.168.8.101:8000/api';  // Your API base URL

  // Fetch all approved products
  Future<List<dynamic>> fetchApprovedProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/products'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['data'];  // Return product list
    } else {
      throw Exception('Failed to load products');
    }
  }

  // Upload a new product (example)
  Future<void> uploadProduct(Map<String, dynamic> productData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/products'),
      body: productData,
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to upload product');
    }
  }
}
