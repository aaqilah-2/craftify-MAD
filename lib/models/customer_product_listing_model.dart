class CustomerProductListing {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  CustomerProductListing({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory CustomerProductListing.fromJson(Map<String, dynamic> json) {
    String baseUrl = 'http://192.168.8.104:8000/storage/';
    return CustomerProductListing(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Product',
      description: json['description'] ?? '',
      price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
      imageUrl: json['image'] != null ? baseUrl + json['image'] : '',
      category: json['category'] ?? 'Uncategorized',
    );
  }
}








// //main working one
// class CustomerProductListing {
//   final int id;
//   final String name;
//   final String description;
//   final double price;
//   final String imageUrl;
//   final String category;
//
//   CustomerProductListing({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.price,
//     required this.imageUrl,
//     required this.category,
//   });
//
//   // Update the parsing logic to construct the full image URL
//   factory CustomerProductListing.fromJson(Map<String, dynamic> json) {
//     String baseUrl = 'http://192.168.8.104:8000/storage/';  // Your base URL to the storage path
//     return CustomerProductListing(
//       id: json['id'] ?? 0,
//       name: json['name'] ?? 'Unknown Product',
//       description: json['description'] ?? '',
//       price: json['price'] != null ? double.tryParse(json['price'].toString()) ?? 0.0 : 0.0,
//       imageUrl: json['image'] != null ? baseUrl + json['image'] : '',  // Append base URL to image path
//       category: json['category'] ?? 'Uncategorized',
//     );
//   }
// }
