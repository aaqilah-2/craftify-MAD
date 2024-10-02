class ArtisanProfile {
  final int userId;
  final String streetAddress;
  final String city;
  final String postalCode;
  final int yearsOfExperience;
  final String bio;
  final String contactNumber;
  final List<String> skills;
  final String? socialMediaLinks;
  final double? serviceRadiusKm;
  final String logo;

  ArtisanProfile({
    required this.userId,
    required this.streetAddress,
    required this.city,
    required this.postalCode,
    required this.yearsOfExperience,
    required this.bio,
    required this.contactNumber,
    required this.skills,
    this.socialMediaLinks,
    this.serviceRadiusKm,
    required this.logo,
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
      skills: json['skills'] is List
          ? List<String>.from(json['skills'])
          : (json['skills'] is String ? (json['skills'] as String).split(', ') : []),
      socialMediaLinks: json['social_media_links'],
      // Handle serviceRadiusKm as either a String or num and convert to double
      serviceRadiusKm: json['service_radius_km'] != null
          ? double.tryParse(json['service_radius_km'].toString()) ?? 0.0
          : null,
      logo: json['logo'] ?? 'assets/images/profilepic.png',
    );
  }
}
