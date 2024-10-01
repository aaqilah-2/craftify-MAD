import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart'; // Import the BottomNavBar

class OrdersScreen extends StatelessWidget {
  // Sample order data (this should come from an API or provider in a real implementation)
  final List<Map<String, String>> orders = [
    {"product": "Ceramic Vase", "customer": "John Doe", "status": "Shipped"},
    {"product": "Wooden Chair", "customer": "Jane Smith", "status": "Delivered"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(orders[index]['product']!),
              subtitle: Text('Customer: ${orders[index]['customer']}\nStatus: ${orders[index]['status']}'),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                // Navigate to order details screen (if you want to show detailed order info)
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Assuming Orders is at index 2 for Artisan
        userRole: 2, // Passing the artisan role as 2
      ),
    );
  }
}
