import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Back action
              },
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            title: Center(
              child: Text(
                'Craftify',
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Settings action
                },
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
            backgroundColor: Colors.pink.shade100,
            pinned: isPortrait,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildCategoryList(context),
                _buildNarrowScreenFavorites(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildCategoryList(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildCategoryItem('All', context),
          SizedBox(width: 10),
          _buildCategoryItem('Jewelry', context),
          SizedBox(width: 10),
          _buildCategoryItem('Accessories', context),
          SizedBox(width: 10),
          _buildCategoryItem('Home Decor', context),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String categoryName, BuildContext context) {
    return Chip(
      label: Text(
        categoryName,
        style: TextStyle(
          color: Colors.black87,
          fontFamily: 'Roboto',
        ),
      ),
      backgroundColor: Colors.grey.shade200,
      shape: StadiumBorder(
        side: BorderSide(color: Colors.grey.shade300),
      ),
    );
  }

  Widget _buildNarrowScreenFavorites(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFavoriteItems(context),
      ),
    );
  }

  List<Widget> _buildFavoriteItems(BuildContext context) {
    return <Widget>[
      _buildFavoriteCard(
        'Majesty Wristlet',
        'assets/images/image9.png',
        4.5,
        'Rs.1750.00',
        context,
      ),
      _buildFavoriteCard(
        'Floral Circle Gold Earrings',
        'assets/images/image10.png',
        4.2,
        'Rs.500.00',
        context,
      ),
      _buildFavoriteCard(
        'Golden Feathered Jewelry',
        'assets/images/image11.png',
        4.8,
        'Rs.1200.00',
        context,
      ),
      _buildFavoriteCard(
        'Crystal Crescent Hanging Ornament',
        'assets/images/image12.png',
        4.6,
        'Rs.800.00',
        context,
      ),
    ];
  }

  Widget _buildFavoriteCard(String title, String imagePath, double rating, String price, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to product details screen
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          double cardWidth = constraints.maxWidth > 600 ? (constraints.maxWidth / 2) - 32 : constraints.maxWidth - 32;
          double imageHeight = cardWidth * 0.75; // Adjust the height based on card width

          return Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.pink.shade50 : Colors.white,
            child: Container(
              width: cardWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                        child: Image.asset(
                          imagePath,
                          height: imageHeight,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Roboto',
                            color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: List.generate(5, (index) {
                            if (index < rating.floor()) {
                              return Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              );
                            } else {
                              return Icon(
                                Icons.star_border,
                                color: Colors.grey,
                                size: 16,
                              );
                            }
                          }),
                        ),
                        SizedBox(height: 4),
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ],
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
