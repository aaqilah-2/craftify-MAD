import 'package:flutter/material.dart';
import 'package:craftify/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen(this.product);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.network(
              product.imageUrl,  // Display product image
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text(
              product.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Text(
              '\$${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(product.description),
            ),
          ],
        ),
      ),
    );
  }
}
