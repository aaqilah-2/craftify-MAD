import 'package:flutter/material.dart';
import '../screens/product_details_screen.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String price;
  final String image;
  final String description;
  final double rating;
  final bool isDarkMode;

  ProductCard({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        // Determine the card and image sizes based on orientation
        double cardWidth = orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.45
            : MediaQuery.of(context).size.width * 0.9;
        double imageHeight = orientation == Orientation.portrait
            ? cardWidth
            : MediaQuery.of(context).size.height * 0.4;

        return GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (context) => DraggableScrollableSheet(
                expand: false,
                builder: (context, scrollController) {
                  return SingleChildScrollView(
                    controller: scrollController,
                    child: Container(
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
          },
          child: Container(
            width: cardWidth,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: cardWidth,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: AssetImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.black : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    price,
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      color: isDarkMode ? Colors.black : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    // Add to Cart action
                  },
                  child: Text(
                    'Add to Cart',
                    style: TextStyle(
                      fontFamily: 'Roboto', // Added font family
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
