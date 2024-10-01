// approval_status.dart

import 'package:flutter/material.dart';
import 'package:craftify/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApprovalStatusScreen extends StatefulWidget {
  @override
  _ApprovalStatusScreenState createState() => _ApprovalStatusScreenState();
}

class _ApprovalStatusScreenState extends State<ApprovalStatusScreen> {
  String selectedStatus = 'pending';  // Default to pending

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsByStatus(selectedStatus);  // Fetch products by status
  }

  void _onStatusChanged(String status) {
    setState(() {
      selectedStatus = status;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsByStatus(status);  // Fetch new products based on status
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Product Approval Status'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Column(
        children: [
          // Status Filter Buttons
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _onStatusChanged('pending'),
                  child: Text('Pending'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStatus == 'pending'
                        ? Colors.pink
                        : Colors.grey,
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _onStatusChanged('rejected'),
                  child: Text('Rejected'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStatus == 'rejected'
                        ? Colors.pink
                        : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: products.isEmpty
                ? Center(child: Text('No products found.'))
                : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductBox(product);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1, userRole: 2),  // Assuming artisan role is 2
    );
  }

  Widget _buildProductBox(product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Display the image if available
          product.imageUrl.isNotEmpty
              ? Image.network(
            product.imageUrl,
            height: 100,
            width: 100,
            fit: BoxFit.cover,
          )
              : Container(
            height: 100,
            width: 100,
            color: Colors.grey,
            child: Icon(Icons.image, size: 50, color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Price: \$${product.price}'),
          Text('Category: ${product.category}'),
          Text('Status: $selectedStatus'),
        ],
      ),
    );
  }
}
