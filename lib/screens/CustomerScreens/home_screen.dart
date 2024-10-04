import 'package:craftify/providers/customer_product_listing_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/widgets/product_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:craftify/models/customer_product_listing_model.dart';

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
    _loadUserRoleAndFetchProducts();
  }

  Future<void> _loadUserRoleAndFetchProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      userRole = prefs.getInt(
          'userRole'); // Retrieve user role from shared preferences
      print("User role retrieved: $userRole");
    });

    String? token = prefs.getString('authToken');
    if (token != null) {
      print("Token found: $token");
      await Provider.of<CustomerProductListingProvider>(context, listen: false)
          .fetchApprovedProducts();
    } else {
      print('No token found. Please log in again.');
    }
  }

  void _onSegmentTapped(int index) {
    setState(() {
      _selectedSegment = index;
      print('Segment tapped: $_selectedSegment');
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    bool isPortrait = MediaQuery
        .of(context)
        .orientation == Orientation.portrait;

    final productProvider = Provider.of<CustomerProductListingProvider>(
        context);
    final isLoading = productProvider.isLoading;
    final products = productProvider.products;

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
            _buildDrawerItem(Icons.diamond, 'Jewelry', context),
            _buildDrawerItem(Icons.checkroom, 'Clothing', context),
            _buildDrawerItem(Icons.home, 'Home Decor', context),
            _buildDrawerItem(Icons.palette, 'Art & Collectibles', context),
            _buildDrawerItem(Icons.toys, 'Toys', context),
            _buildDrawerItem(Icons.handyman, 'Craft Supplies', context),
            _buildDrawerItem(Icons.style, 'Accessories', context),
            _buildDrawerItem(Icons.menu_book, 'Stationery', context),
            _buildDrawerItem(Icons.shopping_bag, 'Bags & Purses', context),
            _buildDrawerItem(Icons.more_horiz, 'Other', context),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            leading: IconButton(
              icon: Icon(
                  Icons.menu, color: isDarkMode ? Colors.white : Colors.black),
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
                icon: Icon(Icons.settings,
                    color: isDarkMode ? Colors.white : Colors.black),
                onPressed: () {
                  print('Settings button tapped.');
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
                          print('Filter button tapped.');
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.notifications),
                        onPressed: () {
                          print('Notifications button tapped.');
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
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSegment == 0 ? Colors.pink
                              .shade100 : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSegmentTapped(1),
                        child: Text(
                          'Popular',
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSegment == 1 ? Colors.pink
                              .shade100 : Colors.grey,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => _onSegmentTapped(2),
                        child: Text(
                          'Recommended',
                          style: TextStyle(color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto'),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedSegment == 2 ? Colors.pink
                              .shade100 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildProductList(products, isDarkMode),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 0, userRole: userRole!)
          : SizedBox(),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
      ),
      onTap: () {
        print('$title tapped.');
      },
    );
  }

  Widget _buildProductList(List<CustomerProductListing> customerProducts,
      bool isDarkMode) {
    if (customerProducts.isEmpty) {
      print("No products found.");
      return Center(child: Text('No products available.'));
    }

    print("Building product list with ${customerProducts.length} products.");
    return GridView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: customerProducts.length,
      itemBuilder: (context, index) {
        print("Displaying product: ${customerProducts[index].name}");
        return ProductCard(
          customerProduct: customerProducts[index],
          isDarkMode: isDarkMode,
        );
      },
    );
  }
}

