import 'package:craftify/providers/ProfileProvider.dart';
//import 'package:craftify/providers/artisan_provider.dart';
import 'package:craftify/providers/customer_product_listing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/providers/product_provider.dart'; // Import ProductProvider
import 'package:craftify/providers/favorites_manager.dart'; // Import the FavoritesManager
import 'routes.dart'; // Import routes.dart file
import 'package:craftify/screens/AuthScreens/login_screen.dart';
import 'package:craftify/screens/AuthScreens/register_screen.dart';
import 'package:craftify/providers/CustomerProfileProvider.dart'; // Import the new CustomerProfileProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // Add your ProfileProvider here
        ChangeNotifierProvider(create: (_) => CustomerProfileProvider()), // Customer Profile Provider
        ChangeNotifierProvider(create: (_) => CustomerProductListingProvider()), // Add CustomerProductListingProvider here
        ChangeNotifierProvider(create: (_) => FavoritesManager()), // Add FavoritesManager here
       // ChangeNotifierProvider(create: (_) => ArtisanProvider()), // Add ArtisanProvider here

      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Craftify',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.grey.shade400,
          selectedItemColor: Colors.pink.shade200,
          unselectedItemColor: Colors.grey.shade800,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.pink.shade200,
          unselectedItemColor: Colors.white,
        ),
      ),
      themeMode: ThemeMode.system, // Switches between dark and light theme based on system settings
      initialRoute: '/', // Initial route is login screen
      routes: appRoutes, // Use the named routes from routes.dart
      onGenerateRoute: generateAnimatedRoute, // Use the custom route animations from routes.dart
    );
  }
}
