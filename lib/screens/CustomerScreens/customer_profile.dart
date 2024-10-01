import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';

class CustomerProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Profile'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Customer Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Email: customer@example.com'),
            SizedBox(height: 10),
            Text('Contact: 9876543210'),
            SizedBox(height: 10),
            Text('Location: XYZ City'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to edit profile screen
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade200,
              ),
              child: Text('Edit Profile'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3, // Assuming Profile tab is at index 3
        userRole: 3, // Passing the role as an integer for customer (3)
      ),
    );
  }
}
