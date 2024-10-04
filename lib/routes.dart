//import 'dart:js';

import 'package:flutter/material.dart';
import 'screens/AuthScreens/login_screen.dart';
import 'screens/AuthScreens/register_screen.dart';
import 'screens/CustomerScreens/home_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/favorites_screen.dart';
import 'profile_screen.dart';
import 'product_details_screen.dart';
import 'screens/ArtisanScreens/artisan_home.dart';
import 'screens/AuthScreens/role_selection.dart';
import 'screens/AuthScreens/artisan_register.dart'; // Artisan Profile Setup
import 'screens/AuthScreens/customer_register.dart'; // Customer Profile Setup

import 'screens/ArtisanScreens/manage_products.dart';
import 'screens/ArtisanScreens/orders_screen.dart'; // Add your Order screen for Artisan
import 'screens/ArtisanScreens/artisan_profile.dart'; // Artisan profile
import 'screens/CustomerScreens/customer_profile.dart'; // Customer profile


// Function to generate route animations
Route<dynamic>? generateAnimatedRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/home':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );


    // case '/cart':
    //   return PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(
    //         opacity: animation,
    //         child: child,
    //       );
    //     },
    //   );
    // case '/favorites':
    //   return PageRouteBuilder(
    //     pageBuilder: (context, animation, secondaryAnimation) => FavoritesScreen(),
    //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //       return FadeTransition(
    //         opacity: animation,
    //         child: child,
    //       );
    //     },
    //   );
    case '/customer_profile':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CustomerProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    case '/artisan_home':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ArtisanHomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    case '/manage_products':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ManageProductsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    case '/orders_screen':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OrdersScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    case '/artisan_profile':
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ArtisanProfileScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      );
    default:
      return null;
  }
}

final Map<String, WidgetBuilder> appRoutes = {
  '/': (context) => LoginScreen(),
  '/register': (context) => RegisterScreen(),
  '/login':(context) => LoginScreen(),

  // Artisan routes
  '/artisan_home': (context) => ArtisanHomeScreen(),
  '/artisan_register': (context) => ArtisanProfileForm(),

  '/manage_products': (context) => ManageProductsScreen(),
  '/orders': (context) => OrdersScreen(),
  '/artisan_profile': (context) => ArtisanProfileScreen(),


  // Customer routes
  '/customer_register': (context) => CustomerProfileForm(),
  '/home': (context) => HomeScreen(), //customer home page
  '/customer_profile': (context) =>CustomerProfileScreen(),





  //old customer routes
 // '/cart': (context) => CartScreen(),
  //'/favorites': (context) => FavoritesScreen(),
 // '/profile': (context) => ProfileScreen(),

};
