import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/product_details_screen.dart';
import 'screens/ArtisanScreens/artisan_home.dart';
import 'screens/role_selection.dart';
import 'screens/artisan_register.dart'; // Artisan Profile Setup
import 'screens/customer_register.dart'; // Customer Profile Setup

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),

  '/cart': (context) => CartScreen(),
  '/favorites': (context) => FavoritesScreen(),
  '/profile': (context) => ProfileScreen(),

  // Artisan routes
  '/artisan_home': (context) => ArtisanHomeScreen(),
  '/artisan_register': (context) => ArtisanProfileForm(),

  // Customer routes
  '/customer_register': (context) => CustomerProfileForm(),
  '/home': (context) => HomeScreen(), //customer home page

  // Role selection route
  //'/role_selection': (context) => RoleSelectionScreen(),
};
