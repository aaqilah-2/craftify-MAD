class ArtisanProfile {
  final int userId;
  final String streetAddress;
  final String city;
  final String postalCode;
  final int yearsOfExperience;
  final String bio;
  final String contactNumber;
  final List<String> skills;
  final String? socialMediaLinks; // Make it optional and nullable
  final double? serviceRadiusKm; // Nullable
  final String logo; // Required field, cannot be null

  ArtisanProfile({
    required this.userId,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.yearsOfExperience,
    required this.bio,
    required this.contactNumber,
    required this.skills,
    this.socialMediaLinks,  // Optional and nullable
    this.serviceRadiusKm,   // Optional and nullable
    required this.logo,     // Required field
  });

  factory ArtisanProfile.fromJson(Map<String, dynamic> json) {
    return ArtisanProfile(
      userId: json['user_id'] ?? 0,
      streetAddress: json['street_address'] ?? '',
      city: json['city'] ?? '',
      postalCode: json['postal_code'] ?? '',
      yearsOfExperience: json['years_of_experience'] ?? 0,
      bio: json['bio'] ?? '',
      contactNumber: json['contact_number'] ?? '',
      // Correct the skills parsing:
      skills: json['skills'] is String ? (json['skills'] as String).split(', ') : [],
      socialMediaLinks: json['social_media_links'], // Can be null
      serviceRadiusKm: (json['service_radius_km'] as num?)?.toDouble(),  // Convert to double, nullable
      logo: json['logo'] ?? 'assets/images/default_logo.png', // Fallback to a default image if null
    );
  }
}
