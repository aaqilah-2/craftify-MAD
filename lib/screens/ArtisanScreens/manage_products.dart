import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/screens/ArtisanScreens/products_listed.dart'; // Updated name for the approved products screen
import 'package:craftify/screens/ArtisanScreens/approval_status.dart'; // Updated name for the product approval status screen
import 'package:craftify/screens/ArtisanScreens/product_upload.dart'; // Import the Upload Product screen

class ManageProductsScreen extends StatefulWidget {
  @override
  _ManageProductsScreenState createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen> {
  int? userRole;

  @override
  void initState() {
    super.initState();
    _loadUserRole();
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProductContainer(
              label: 'View Listed Products',
              description: 'See all approved products.',
              color: Colors.blue.shade100,
              icon: Icons.check_circle_outline,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductsListedScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildProductContainer(
              label: 'View Product Approval Status',
              description: 'Check pending and rejected products.',
              color: Colors.orange.shade100,
              icon: Icons.pending_actions,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApprovalStatusScreen()),
                );
              },
            ),
            SizedBox(height: 20),
            _buildProductContainer(
              label: 'Add New Product',
              description: 'Upload a new product',
              color: Colors.green.shade100,
              icon: Icons.add,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadProductScreen()),  // Navigate to the upload screen
                );
              },
            ),

          ],
        ),
      ),
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 1, userRole: userRole!)
          : SizedBox(), // Show BottomNavBar only after userRole is loaded
    );
  }

  Widget _buildProductContainer({
    required String label,
    required String description,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: Colors.white),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(description),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
