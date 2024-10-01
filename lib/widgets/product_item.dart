import 'package:flutter/material.dart';
import 'package:craftify/models/product.dart';
import 'package:craftify/screens/CustomerScreens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.network(
                product.imageUrl,  // Display product image
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(product.name, style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('\$${product.price}', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
