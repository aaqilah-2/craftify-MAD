import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/providers/CustomerProfileProvider.dart';
import 'edit_profile.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  int? userRole;

  @override
  void initState() {
    super.initState();
    Provider.of<CustomerProfileProvider>(context, listen: false).fetchCustomerProfile();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole');
      print('User role retrieved: $userRole');
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<CustomerProfileProvider>(context);
    final profile = profileProvider.customerProfile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.pink.shade100,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              profileProvider.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: profile != null
          ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Profile picture with Image.network fallback logic
              CircleAvatar(
                radius: 50,
                backgroundImage: profile.profilePhotoUrl != null && profile.profilePhotoUrl!.isNotEmpty
                    ? NetworkImage(profile.profilePhotoUrl!)
                    : AssetImage('assets/images/profilepic.png') as ImageProvider,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCustomerProfileScreen(profile: profile),
                    ),
                  );
                },
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Makes the text bold
                    color: Colors.black, // Changes the text color to black
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
              SizedBox(height: 30),
              ListTile(
                title: Text(
                  'Account Overview',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              _buildProfileTile(context, 'Name', profile.name, Icons.person),
              _buildProfileTile(context, 'Email', profile.email, Icons.email),
              _buildProfileTile(context, 'Phone', profile.phoneNumber, Icons.phone),
              _buildProfileTile(context, 'City', profile.city, Icons.location_city),
              _buildProfileTile(context, 'Street Address', profile.streetAddress, Icons.home),
              _buildProfileTile(context, 'Postal Code', profile.postalCode, Icons.mail),
              _buildProfileTile(context, 'Preferences', profile.preferences?.join(', ') ?? 'None', Icons.favorite),
              _buildProfileTile(context, 'Payment Methods', profile.preferredPaymentMethods?.join(', ') ?? 'None', Icons.payment),
            ],
          ),
        ),
      )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 3, userRole: userRole!) // Assuming the Profile tab is at index 3
          : SizedBox(),
    );
  }

  Widget _buildProfileTile(BuildContext context, String label, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink.shade100),
      title: Text(
        label,
        style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontFamily: 'Roboto', fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.pink.shade100),
    );
  }
}
