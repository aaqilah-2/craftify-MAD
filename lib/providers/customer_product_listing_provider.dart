import 'package:flutter/material.dart';
import 'package:craftify/services/customer_product_listing_service.dart';
import 'package:craftify/models/customer_product_listing_model.dart';

class CustomerProductListingProvider extends ChangeNotifier {
  List<CustomerProductListing> _customerProducts = [];
  bool _isLoading = false;

  List<CustomerProductListing> get products => _customerProducts;
  bool get isLoading => _isLoading;

  final CustomerProductListingService _service = CustomerProductListingService();

  Future<void> fetchApprovedProducts() async {
    print('Fetching approved products...');
    _isLoading = true;
    notifyListeners();

    try {
      final List<dynamic> productData = await _service.getApprovedProducts();

      // Log each fetched product to see if data is correctly retrieved
      productData.forEach((product) {
        print('Fetched product JSON: $product');
      });

      _customerProducts = productData
          .map((productJson) => CustomerProductListing.fromJson(productJson))
          .toList();

      // Log the parsed customerProducts to ensure proper mapping
      _customerProducts.forEach((product) {
        print('Parsed Product: Name: ${product.name}, ImageUrl: ${product.imageUrl}');
      });

      print('Fetched ${_customerProducts.length} products');
    } catch (error) {
      print('Error fetching products: $error');
    }

    _isLoading = false;
    notifyListeners();
  }
}
