import 'package:flutter/material.dart';

class ProductDetailsScreen extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final String description;
  final double rating;

  ProductDetailsScreen({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DraggableScrollableSheet(
        initialChildSize: 0.7, // 70% of screen height
        minChildSize: 0.4, // 40% of screen height
        maxChildSize: 0.9, // 90% of screen height
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.black : Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              border: Border.all(
                color: Colors.pink.shade100,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.pink.shade100.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(image),
                  SizedBox(height: 20),
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    price,
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      fontSize: 20,
                      color: isDarkMode ? Colors.pink.shade100 : Colors.pink,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description:',
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amberAccent, size: 24),
                      SizedBox(width: 5),
                      Text(
                        '$rating',
                        style: TextStyle(
                          fontFamily: 'Roboto', // Added font family
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Add to favourites action
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.pink.shade100,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Add to favourites',
                      style: TextStyle(
                        fontFamily: 'Roboto', // Added font family
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
