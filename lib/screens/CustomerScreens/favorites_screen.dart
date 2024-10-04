import 'package:craftify/providers/favorites_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/widgets/product_card.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:craftify/models/customer_product_listing_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/customer_product_listing_provider.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  int? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    // Get the user's role from local storage (SharedPreferences)
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole');
    });
  }

  // Method to remove a product from favorites
  Future<void> _removeFromFavorites(String productId) async {
    // Use the FavoritesManager to handle the removal logic
    Provider.of<FavoritesManager>(context, listen: false)
        .toggleFavorite(int.parse(productId));
    _showSnackbar(context, 'Removed from favorites');
  }

  // Method to show snackbars for user notifications
  void _showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    // Access FavoritesManager from Provider
    final favoritesManager = Provider.of<FavoritesManager>(context);
    final favoriteProductIds = favoritesManager.favoriteProductIds;
    final allProducts = Provider.of<CustomerProductListingProvider>(context).products;

    // Get favorite products by matching IDs from allProducts
    final favoriteProducts = allProducts.where((product) => favoriteProductIds.contains(product.id)).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Center(
              child: Text(
                'Favorites',
                style: TextStyle(color: Colors.black, fontFamily: 'Roboto'),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  print('Settings button tapped.');
                },
              ),
            ],
            backgroundColor: Colors.pink.shade100,
            floating: true,
            pinned: isPortrait,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: favoriteProducts.isEmpty
                ? Center(child: Text('No favorite products found.'))
                : GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = favoriteProducts[index];
                return ProductCard(
                  customerProduct: product,
                  isDarkMode: isDarkMode,
                  onFavoriteToggle: () {
                    _removeFromFavorites(product.id.toString()); // Remove from favorites
                  },
                  isFavorite: true, // Mark as favorite
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 2, userRole: userRole!)
          : SizedBox(),
    );
  }
}
