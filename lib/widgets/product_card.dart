import 'package:flutter/material.dart';
import '../models/customer_product_listing_model.dart';

class ProductCard extends StatelessWidget {
  final CustomerProductListing customerProduct;
  final bool isDarkMode;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  ProductCard({
    required this.customerProduct,
    required this.isDarkMode,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        double cardWidth = orientation == Orientation.portrait
            ? MediaQuery.of(context).size.width * 0.45
            : MediaQuery.of(context).size.width * 0.9;

        double imageAspectRatio = 1; // Square aspect ratio for better layout

        return GestureDetector(
          onTap: () {
            print('Product tapped: ${customerProduct.name}');
          },
          child: Container(
            width: cardWidth,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: AspectRatio(
                    aspectRatio: imageAspectRatio,
                    child: customerProduct.imageUrl.isNotEmpty
                        ? Image.network(
                      customerProduct.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey,
                          child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                        );
                      },
                    )
                        : Container(
                      color: Colors.grey,
                      child: Icon(Icons.image, size: 50, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    customerProduct.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${customerProduct.price}',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: onFavoriteToggle,
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.white,
                  ),
                  label: Text(
                    isFavorite ? 'Remove from Favourites' : 'Add to Favourites',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}






//
// import 'package:flutter/material.dart';
// import '../models/customer_product_listing_model.dart';
//
// class ProductCard extends StatelessWidget {
//   final CustomerProductListing customerProduct;
//   final bool isDarkMode;
//
//   ProductCard({
//     required this.customerProduct,
//     required this.isDarkMode,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return OrientationBuilder(
//       builder: (context, orientation) {
//         double cardWidth = orientation == Orientation.portrait
//             ? MediaQuery.of(context).size.width * 0.45
//             : MediaQuery.of(context).size.width * 0.9;
//
//         // Ensure consistent aspect ratio for the image
//         double imageAspectRatio = 1; // Square aspect ratio for better layout
//
//         return GestureDetector(
//           onTap: () {
//             print('Product tapped: ${customerProduct.name}');
//           },
//           child: Container(
//             width: cardWidth,
//             margin: EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.grey.withOpacity(0.5),
//                   spreadRadius: 2,
//                   blurRadius: 5,
//                   offset: Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Use Flexible or Expanded to prevent overflow
//                 Flexible(
//                   flex: 2, // Controls the space the image takes
//                   child: AspectRatio(
//                     aspectRatio: imageAspectRatio, // Set aspect ratio
//                     child: customerProduct.imageUrl.isNotEmpty
//                         ? Image.network(
//                       customerProduct.imageUrl,
//                       fit: BoxFit.cover,  // Ensures the image covers the container
//                       loadingBuilder: (context, child, loadingProgress) {
//                         if (loadingProgress == null) return child;
//                         return Center(
//                           child: CircularProgressIndicator(
//                             value: loadingProgress.expectedTotalBytes != null
//                                 ? loadingProgress.cumulativeBytesLoaded /
//                                 loadingProgress.expectedTotalBytes!
//                                 : null,
//                           ),
//                         );
//                       },
//                       errorBuilder: (context, error, stackTrace) {
//                         print('Error loading image: ${customerProduct.imageUrl}');
//                         return Container(
//                           color: Colors.grey,
//                           child: Icon(Icons.broken_image, size: 50, color: Colors.white),
//                         );
//                       },
//                     )
//                         : Container(
//                       color: Colors.grey,
//                       child: Icon(Icons.image, size: 50, color: Colors.white),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     customerProduct.name,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                       color: isDarkMode ? Colors.white : Colors.black,
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: Text(
//                     '\$${customerProduct.price}',
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       color: isDarkMode ? Colors.white : Colors.grey,
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.pink.shade100,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   onPressed: () {
//                     print('Add to Favourites: ${customerProduct.name}');
//                   },
//                   child: Text(
//                     'Add to Favourites',
//                     style: TextStyle(
//                       fontFamily: 'Roboto',
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }//working code i like
