import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/providers/product_provider.dart';
import 'package:craftify/models/product.dart';
import 'package:craftify/screens/ArtisanScreens/product_upload.dart';

import 'edit_product.dart'; // If you want to navigate to edit product screen
class ProductsListedScreen extends StatefulWidget {
  @override
  _ProductsListedScreenState createState() => _ProductsListedScreenState();
}

class _ProductsListedScreenState extends State<ProductsListedScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    productProvider.fetchProductsByStatus('approved');  // Automatically refresh products on entering the screen
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductProvider>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Listed Products'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: products.isEmpty
          ? Center(child: Text('No listed products found.'))
          : ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductBox(context, product);
        },
      ),
    );
  }

  Widget _buildProductBox(BuildContext context, Product product) {
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
            Text(
              product.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Price: \$${product.price}'),
            Text('Category: ${product.category}'),
            Text('Status: Approved'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Navigate to edit product screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProductScreen(product: product), // Can pass product details here to pre-fill form
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    // Confirm delete
                    final confirm = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Delete Product'),
                        content: Text('Are you sure you want to delete this product?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          TextButton(
                            child: Text('Delete'),
                            onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                    );

                    if (confirm == true) {
                      // Delete product
                      Provider.of<ProductProvider>(context, listen: false)
                          .deleteProduct(product.id);
                    }
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
