import 'package:craftify/providers/ProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/providers/product_provider.dart'; // Import ProductProvider
import 'routes.dart'; // Import routes.dart file
import 'package:craftify/screens/AuthScreens/login_screen.dart';
import 'package:craftify/screens/AuthScreens/register_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()), // Add your ProfileProvider here
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
