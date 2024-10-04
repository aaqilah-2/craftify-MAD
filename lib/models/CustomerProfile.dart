class CustomerProfile {
  final String name;
  final String email;
  final String phoneNumber;
  final String city;
  final String streetAddress;
  final String postalCode;
  final List<String>? preferences;
  final List<String>? preferredPaymentMethods;

  CustomerProfile({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.city,
    required this.streetAddress,
    required this.postalCode,
    this.preferences,
    this.preferredPaymentMethods,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      name: json['user']['name'], // User's name
      email: json['user']['email'], // User's email
      phoneNumber: json['phone_number'],
      city: json['city'],
      streetAddress: json['street_address'],
      postalCode: json['postal_code'],
      preferences: List<String>.from(json['preferences'] ?? []),
      preferredPaymentMethods: List<String>.from(json['preferred_payment_methods'] ?? []),
    );
  }
}
