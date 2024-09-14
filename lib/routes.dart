import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_details_screen.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/home': (context) => HomeScreen(),
  '/cart': (context) => CartScreen(),
  '/favorites': (context) => FavoritesScreen(),
  '/profile': (context) => ProfileScreen(),
 // '/product_details': (context) => ProductDetailsScreen(),
};
