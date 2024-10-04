import 'dart:convert';

class CustomerProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String city;
  final String streetAddress;
  final String postalCode;
  final List<String>? preferences;
  final List<String>? preferredPaymentMethods;
  final String? profilePhotoUrl;

  CustomerProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.streetAddress,
    required this.postalCode,
    this.preferences,
    this.preferredPaymentMethods,
    this.profilePhotoUrl,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    String baseUrl = 'http://192.168.8.104:8000/storage/';  // Replace with your base URL
    return CustomerProfile(
      name: json['name'] ?? '',  // Provide defaults if null
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      city: json['city'] ?? '',
      streetAddress: json['street_address'] ?? '',
      postalCode: json['postal_code'] ?? '',
      preferences: json['preferences'] != null ? List<String>.from(json['preferences']) : [],  // Handle null for lists
      preferredPaymentMethods: json['preferred_payment_methods'] is List
          ? List<String>.from(json['preferred_payment_methods'])
          : json['preferred_payment_methods'] != null
          ? List<String>.from(jsonDecode(json['preferred_payment_methods']))
          : [],
      // Ensure profile_photo_url is a String or return an empty string if null
      profilePhotoUrl: json['profile_photo_url'] != null ? baseUrl + json['profile_photo_url'] : '', // Default to an empty string
    );
  }

}
//shapseies