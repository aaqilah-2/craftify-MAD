import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: Icon(Icons.menu), // Drawer icon
                  onPressed: () {
                    Scaffold.of(context).openDrawer(); // Open drawer action
                  },
                  color: isDarkMode ? Colors.white : Colors.black,
                );
              },
            ),
            title: Center(
              child: Text(
                'Craftify',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  color: Colors.black,
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
            floating: false,
          ),
          SliverToBoxAdapter(
            child: _buildProfileContent(context),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(
                "HI, TAYLOR!",
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/profilepic.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onTap: () {
                // Handle settings
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text(
                'Help',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onTap: () {
                // Handle help
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onTap: () {
                // Handle logout
              },
            ),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text(
                'Edit Profile',
                style: TextStyle(fontFamily: 'Roboto'),
              ),
              onTap: () {
                // Handle edit profile
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }

  Widget _buildProfileContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profilepic.png'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Edit profile action
                  },
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.pink.shade100
                        : Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          ListTile(
            title: Text(
              'Account Overview',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text(
              'Personal Information',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle personal information
            },
          ),
          ListTile(
            leading: Icon(Icons.security),
            title: Text(
              'Security Settings',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle security settings
            },
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Payment Methods',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle payment methods
            },
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'My Collection',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(
              'Favorites',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle favorites
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_basket),
            title: Text(
              'My Purchases',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle my purchases
            },
          ),
          SizedBox(height: 10),
          ListTile(
            title: Text(
              'Customization',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.palette),
            title: Text(
              'Theme',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle theme customization
            },
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text(
              'Language',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle language
            },
          ),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text(
              'Notification Settings',
              style: TextStyle(fontFamily: 'Roboto'),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              // Handle notification settings
            },
          ),
        ],
      ),
    );
  }
}
