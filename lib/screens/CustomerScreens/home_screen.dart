import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:craftify/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSegment = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole'); // Retrieve user role from shared preferences
    });
  }

  void _onSegmentTapped(int index) {
    setState(() {
      _selectedSegment = index;
    });
  }

  Widget _buildSegmentContent() {
    // Placeholder data for product cards
    List<ProductCardData> products = [
      ProductCardData(
        title: 'Ceramic Bug Cube',
        price: 'Rs.1000.00',
        image: 'assets/images/image1.png',
        description:
        'A unique square-shaped ceramic piece, artfully designed in sleek black. This bug-inspired sculpture adds a touch of whimsical elegance to any space.',
        rating: 4.5,
      ),
      ProductCardData(
        title: 'Ebon Cream Wall Art',
        price: 'Rs.2000.00',
        image: 'assets/images/image2.png',
        description:
        'A striking piece of wall art featuring a harmonious blend of black and cream colors. This handcrafted artwork is perfect for adding a modern yet rustic charm to your decor.',
        rating: 3.8,
      ),
      // Add more products as needed
    ];

    // Filter products based on selected segment (not implemented in this example)
    return Column(
      children: List.generate(products.length ~/ 2, (index) {
        int startIndex = index * 2;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ProductCard(
              title: products[startIndex].title,
              price: products[startIndex].price,
              image: products[startIndex].image,
              description: products[startIndex].description,
              rating: products[startIndex].rating,
              isDarkMode: Theme.of(context).brightness == Brightness.dark,
            ),
            if (startIndex + 1 < products.length)
              ProductCard(
                title: products[startIndex + 1].title,
                price: products[startIndex + 1].price,
                image: products[startIndex + 1].image,
                description: products[startIndex + 1].description,
                rating: products[startIndex + 1].rating,
                isDarkMode: Theme.of(context).brightness == Brightness.dark,
              ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
              ),
              child: Text(
                'CATEGORIES',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.art_track),
              title: Text('WALL ART', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Wall Art category
              },
            ),
            // Add more categories here
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.menu, color: isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                _scaffoldKey.currentState?.openDrawer();
              },
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
                icon: Icon(Icons.settings, color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  // Settings action
                },
              ),
            ],
            backgroundColor: Colors.pink.shade100,
            floating: true,
            pinned: isPortrait,
            snap: true,
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.search),
                            hintText: 'Search products',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          // Filter action
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          // Notification action
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onSegmentTapped(0),
                        child: Text(
                          'Recent',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSegment == 0 ? Colors.pink.shade100 : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSegmentTapped(1),
                        child: Text(
                          'Popular',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSegment == 1 ? Colors.pink.shade100 : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSegmentTapped(2),
                        child: Text(
                          'Recommended',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSegment == 2 ? Colors.pink.shade100 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildSegmentContent(),
              ],
            ),
          ),
        ],
      ),
      // Add BottomNavBar with userRole for customer
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 0, userRole: userRole!) // Assuming 0 is for Home
          : SizedBox(), // Show nothing until userRole is loaded
    );
  }
}

class ProductCardData {
  final String title;
  final String price;
  final String image;
  final String description;
  final double rating;

  ProductCardData({
    required this.title,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
  });
}
