import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:craftify/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedSegment = 0;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
        description: 'A unique square-shaped ceramic piece, artfully designed in sleek black. This bug-inspired sculpture adds a touch of whimsical elegance to any space. Each piece is meticulously handcrafted, ensuring that no two are exactly alike. Perfect as a conversation starter or a distinctive addition to your home decor collection.',
        rating: 4.5,
      ),
      ProductCardData(
        title: 'Ebon Cream Wall Art',
        price: 'Rs.2000.00',
        image: 'assets/images/image2.png',
        description: 'A striking piece of wall art featuring a harmonious blend of black and cream colors. This handcrafted artwork is perfect for adding a modern yet rustic charm to your decor. Its intricate design and rich textures make it a standout piece, ideal for living rooms, bedrooms, or office spaces. Celebrate the fusion of contemporary and traditional artistry with this beautiful creation.',
        rating: 3.8,
      ),
      ProductCardData(
        title: 'Keepsake Box',
        price: 'Rs.3000.00',
        image: 'assets/images/image3.png',
        description: 'This exquisite box is crafted from delicately stitched bamboo canes. Perfect for storing your treasured items, it brings a touch of nature\'s beauty into your home. The natural materials and careful craftsmanship ensure durability and a unique aesthetic. Use it to keep jewelry, trinkets, or cherished mementos safe while adding a rustic charm to your space.',
        rating: 4.2,
      ),
      ProductCardData(
        title: 'Bamboo Cake Tray',
        price: 'Rs.4000.00',
        image: 'assets/images/image4.png',
        description: 'A beautifully handcrafted tray made from bamboo canes, ideal for serving cakes and pastries. Its rustic elegance makes it a perfect centerpiece for your gatherings. The sturdy yet lightweight design allows for easy handling, and the natural bamboo finish complements any decor style. Impress your guests with this eco-friendly, artisanal serving piece.',
        rating: 4.0,
      ),
      ProductCardData(
        title: 'Artisan Carry Box',
        price: 'Rs.5000.00',
        image: 'assets/images/image5.png',
        description: 'A handmade carrier box that combines functionality with aesthetic appeal. Its sturdy construction and natural finish make it ideal for transporting goods with style. Whether you are heading to a picnic, market, or simply organizing at home, this carrier box offers practicality and charm. Each box is crafted with care, reflecting the skill and dedication of the artisan.',
        rating: 4.7,
      ),
      ProductCardData(
        title: 'Feather Charm Stick',
        price: 'Rs.6000.00',
        image: 'assets/images/image6.png',
        description: 'An enchanting ornament stick adorned with delicate feathers. This handcrafted piece adds a bohemian flair to any setting, perfect for enhancing your decorative arrangements. The lightweight design and natural materials make it a versatile accessory for both indoor and outdoor spaces. Hang it in your garden, living room, or bedroom to evoke a sense of tranquility and artistic expression.',
        rating: 4.1,
      ),
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
            ListTile(
              leading: Icon(Icons.kitchen),
              title: Text('KITCHEN & DINE', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Kitchen & Dine category
              },
            ),
            ListTile(
              leading: Icon(Icons.bathtub),
              title: Text('BATH & BODY', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Bath & Body category
              },
            ),
            ListTile(
              leading: Icon(Icons.diamond),
              title: Text('JEWELRY', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Jewelry category
              },
            ),
            ListTile(
              leading: Icon(Icons.brush),
              title: Text('CRAFT SUPPLIES & TOOLS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Craft Supplies & Tools category
              },
            ),
            ListTile(
              leading: Icon(Icons.checkroom),
              title: Text('CLOTHING', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Clothing category
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text('OFFERS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Offers section
              },
            ),
            ListTile(
              leading: Icon(Icons.new_releases),
              title: Text('NEW ARRIVALS', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to New Arrivals section
              },
            ),
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
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
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
