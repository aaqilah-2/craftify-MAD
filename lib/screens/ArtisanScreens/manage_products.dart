import 'package:craftify/screens/ArtisanScreens/product_upload.dart';
import 'package:flutter/material.dart';
import 'package:craftify/providers/product_provider.dart';
import 'package:provider/provider.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/product.dart'; // Import BottomNavBar

class ManageProductsScreen extends StatefulWidget {
  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  int? userRole;
  String selectedStatus = 'pending'; // Default status filter

  @override
  void initState() {
    super.initState();
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsByStatus(selectedStatus);
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole'); // Retrieve user role from shared preferences
    });
  }

  void _onStatusChanged(String status) {
    setState(() {
      selectedStatus = status;
    });
    Provider.of<ProductProvider>(context, listen: false)
        .fetchProductsByStatus(status);
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
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
                  onPressed: () => _onStatusChanged('approved'),
                  child: Text('Approved'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedStatus == 'approved'
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade200,
        child: Icon(Icons.add),
        onPressed: () {
          // Navigate to Product Upload screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UploadProductScreen()),
          );
        },
      ),
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 1, userRole: userRole!)
          : SizedBox(), // Show BottomNavBar only after userRole is loaded
    );
  }

  // Product Box Design
  Widget _buildProductBox(Product product) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Check if the product has an image
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
            Text(
              product.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Price: \$${product.price}'),
            Text('Category: ${product.category}'),
            Text('Status: ${selectedStatus}'), // Shows current status
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Navigate to edit product screen
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete product functionality
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
