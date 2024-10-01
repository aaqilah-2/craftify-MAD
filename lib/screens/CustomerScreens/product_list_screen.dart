import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/providers/product_provider.dart';
import 'package:craftify/widgets/product_item.dart';
import 'package:craftify/screens/CustomerScreens/product_detail_screen.dart';

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: FutureBuilder(
        future: Provider.of<ProductProvider>(context, listen: false).fetchProducts(), // Fetch products
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading products'));
          } else {
            return Consumer<ProductProvider>(
              builder: (ctx, productProvider, _) {
                return GridView.builder(
                  padding: const EdgeInsets.all(10.0),
                  itemCount: productProvider.products.length,
                  itemBuilder: (ctx, i) => ProductItem(productProvider.products[i]),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
