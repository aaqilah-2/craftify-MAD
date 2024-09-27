import 'package:craftify/screens/cart_screen.dart';
import 'package:craftify/screens/favorites_screen.dart';
import 'package:craftify/screens/home_screen.dart';
import 'package:craftify/screens/login_screen.dart';
import 'package:craftify/screens/product_details_screen.dart';
import 'package:craftify/screens/profile_screen.dart';
import 'package:craftify/screens/register_screen.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'routes.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Craftify',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white, // Light mode background color
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey.shade400,
          selectedItemColor: Colors.pink.shade200,
          unselectedItemColor: Colors.grey.shade800,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Dark mode background color
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.pink.shade200,
          unselectedItemColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system, //This should ensure the theme changes automatically based on the system setting.
      initialRoute: '/',
      routes: appRoutes,
      onGenerateRoute: (settings) {
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
          case '/cart':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => CartScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/favorites':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => FavoritesScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            );
          case '/profile':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ProfileScreen(),
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
      },
    );
  }
}
