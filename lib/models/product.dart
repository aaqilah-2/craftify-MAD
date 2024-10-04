//wihtout favs
class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;


  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Safe parsing of the price
    double parsedPrice = 0.0;
    try {
      // Attempt to parse the price to double
      parsedPrice = double.parse(json['price'].toString());
    } catch (e) {
      print('Price parsing error: $e');
    }

    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: parsedPrice,  // Use the parsed price
      imageUrl: json['image_url'],  // Full image URL
      category: json['category'],
    );
  }
}