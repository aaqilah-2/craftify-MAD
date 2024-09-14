import 'package:flutter/material.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    bool isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                // Back action
              },
              color: isDarkMode ? Colors.white : Colors.black,
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
                icon: Icon(Icons.settings),
                onPressed: () {
                  // Settings action
                },
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ],
            backgroundColor: Colors.pink.shade100,
            pinned: isPortrait,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                _buildCartHeader(),
                _buildCartItems(context),
                _buildPriceDetails(context),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      // Proceed to checkout
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink.shade100,
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 80), // Additional space for bottom navigation bar
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 1),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    );
  }

  Widget _buildCartHeader() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade200,
      padding: EdgeInsets.all(8),
      child: Center(
        child: Text(
          'My Cart',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.pink.shade200,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  Widget _buildCartItems(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildCartItem(
          context,
          'Stellar Charm Necklace',
          'assets/images/image8.png',
          'Rs.1750.00',
        ),
        SizedBox(height: 16),
        _buildCartItem(
          context,
          'Emerald Brooch',
          'assets/images/image7.png',
          'Rs.500.00',
        ),
        SizedBox(height: 16),
        _buildCartItem(
          context,
          'Golden Feathered Jewelry',
          'assets/images/image11.png',
          'Rs.1200.00',
        ),
      ],
    );
  }

  Widget _buildCartItem(BuildContext context, String title, String imagePath, String price) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: isDarkMode ? Colors.pink.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove, color: Colors.black),
                        onPressed: () {
                          // Decrease quantity
                        },
                      ),
                      Text('1', style: TextStyle(color: Colors.black)), // Quantity here
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          // Increase quantity
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.black),
                  onPressed: () {
                    // Remove item from cart
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Price Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Roboto',
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Product Price', style: TextStyle(fontFamily: 'Roboto')),
              Text('Rs.3450.00', style: TextStyle(fontFamily: 'Roboto')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Delivery Charges', style: TextStyle(fontFamily: 'Roboto')),
              Text('Rs.100.00', style: TextStyle(fontFamily: 'Roboto')),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order Total',
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              ),
              Text(
                'Rs.3550.00',
                style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
