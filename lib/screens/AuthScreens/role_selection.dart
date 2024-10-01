import 'package:flutter/material.dart';

class RoleSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.pink.shade50,
      appBar: AppBar(
        title: Text(
          'Select Your Role',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.pink.shade100 : Colors.pink.shade50,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Artisan Box
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/artisan_register');
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.handyman_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Are you an Artisan?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Register as an Artisan and showcase your handcrafted products to a wide range of buyers looking for unique, custom creations.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/artisan_register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Register as Artisan',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.pink.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Customer Box
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/customer_register');
              },
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.shopping_cart_rounded,
                      size: 60,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Looking to Buy?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Register as a Customer to explore a curated selection of artisanal products and support local craftsmanship.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        color: Colors.white70,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/customer_register');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Register as Customer',
                        style: TextStyle(
                          fontFamily: 'Roboto',
                          color: Colors.pink.shade100,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
