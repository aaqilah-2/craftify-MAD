import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final int userRole; // Accept user role as an integer

  BottomNavBar({required this.currentIndex, required this.userRole});

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
      });
      // Handle navigation based on the role (using integer roles)
      if (widget.userRole == 2) { // Artisan
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/artisan_home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/manage_products');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/orders');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/artisan_profile');
            break;
        }
      } else if (widget.userRole == 3) { // Customer
        switch (index) {
          case 0:
            Navigator.pushReplacementNamed(context, '/home');
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/cart');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/favorites');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onItemTapped,
      items: widget.userRole == 2
          ? const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.store),
          label: 'Manage Products',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ]
          : const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Cart',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Favorites',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
