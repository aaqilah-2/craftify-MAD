import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:craftify/providers/CustomerProfileProvider.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile.dart';

class CustomerProfileScreen extends StatefulWidget {
  @override
  _CustomerProfileScreenState createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  int? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole(); // Load user role to pass to the bottom navigation bar
    _fetchProfileData(); // Fetch customer profile data
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole'); // Load user role
    });
  }

  Future<void> _fetchProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    if (token != null) {
      Provider.of<CustomerProfileProvider>(context, listen: false).fetchCustomerProfile(token);
    }
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token != null) {
      final response = await http.post(
        Uri.parse('http://192.168.8.104:8000/api/logout'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Remove token from SharedPreferences
        await prefs.remove('authToken');
        await prefs.remove('userRole');

        // Navigate back to login screen
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logout failed. Please try again.')),
        );
      }
    }
  }

  void _editProfile(BuildContext context) {
    final profileProvider = Provider.of<CustomerProfileProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCustomerProfileScreen(
          profile: profileProvider.customerProfile!, // Pass the current profile object
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<CustomerProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Profile'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: profileProvider.customerProfile != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              profileProvider.customerProfile?.name ?? 'No name provided',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: ${profileProvider.customerProfile?.email ?? 'No email'}'),
            SizedBox(height: 10),
            Text('Contact: ${profileProvider.customerProfile?.phoneNumber ?? 'No contact'}'),
            SizedBox(height: 10),
            Text('Location: ${profileProvider.customerProfile?.city ?? 'No location'}'),
            SizedBox(height: 10),
            Text('Street Address: ${profileProvider.customerProfile?.streetAddress ?? 'No address'}'),
            SizedBox(height: 10),
            Text('Postal Code: ${profileProvider.customerProfile?.postalCode ?? 'No postal code'}'),
            SizedBox(height: 10),
            Text('Preferences: ${profileProvider.customerProfile?.preferences?.join(", ") ?? 'No preferences'}'),
            SizedBox(height: 10),
            Text('Payment Methods: ${profileProvider.customerProfile?.preferredPaymentMethods?.join(", ") ?? 'No payment methods'}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _editProfile(context); // Call the function to navigate to edit profile
                // Navigate to edit profile screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade200,
              ),
              child: Text('Edit Profile'),
            ),
          ],
        ),
      )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 3, userRole: userRole!) // Assuming Profile tab is at index 3
          : SizedBox(), // Show nothing until userRole is loaded
    );
  }
}
