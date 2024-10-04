import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart'; // Import BottomNavBar

class ArtisanHomeScreen extends StatefulWidget {
  @override
  _ArtisanHomeScreenState createState() => _ArtisanHomeScreenState();
}

class _ArtisanHomeScreenState extends State<ArtisanHomeScreen> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                'ARTISAN MENU',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.store),
              title: Text('Manage Products', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Placeholder for future functionality
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Orders', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Orders screen
                // Placeholder: Add the Orders screen here when available
              },
            ),
            ListTile(
              leading: Icon(Icons.analytics),
              title: Text('Analytics', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto')),
              onTap: () {
                // Navigate to Analytics screen
                // Placeholder: Add the Analytics screen here when available
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
                'Artisan Dashboard',
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to the Artisan Dashboard!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                      color: isDarkMode ? Colors.pink.shade100 : Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Artisan Dashboard Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDashboardBox(
                        icon: Icons.store,
                        label: 'Manage Products',
                        color: Colors.blue.shade100,
                        onTap: () {
                          // Placeholder for Manage Products action
                        },
                      ),
                      _buildDashboardBox(
                        icon: Icons.shopping_cart,
                        label: 'Orders',
                        color: Colors.green.shade100,
                        onTap: () {
                          // Orders action placeholder
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildDashboardBox(
                        icon: Icons.analytics,
                        label: 'Analytics',
                        color: Colors.purple.shade100,
                        onTap: () {
                          // Analytics action placeholder
                        },
                      ),
                      _buildDashboardBox(
                        icon: Icons.settings,
                        label: 'Settings',
                        color: Colors.orange.shade100,
                        onTap: () {
                          // Settings action placeholder
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Add the BottomNavBar here for navigation across screens
      bottomNavigationBar: BottomNavBar(currentIndex: 0, userRole: 2), // Assuming 0 is for the Home Screen
    );
  }

  // Dashboard box widget
  Widget _buildDashboardBox({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
