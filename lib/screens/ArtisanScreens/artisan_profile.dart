import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:craftify/providers/ProfileProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/screens/ArtisanScreens/edit_profile.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart';
import 'package:craftify/models/ArtisanProfile.dart';
import 'package:craftify/models/User.dart';

class ArtisanProfileScreen extends StatefulWidget {
    @override
    _ArtisanProfileScreenState createState() => _ArtisanProfileScreenState();
}

class _ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
    int? userRole;
    bool isLoading = true;

    @override
    void initState() {
        super.initState();
        _loadUserRole(); // Fetch the stored user role
        _fetchProfileData(); // Fetch the profile data from the server
    }

    Future<void> _logout(BuildContext context) async {
        try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('authToken');

            if (token != null) {
                final response = await http.post(
                    Uri.parse('http://192.168.8.104:8000/api/logout'),
                    headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                    },
                );

                if (response.statusCode == 200) {
                    await prefs.remove('authToken');
                    await prefs.remove('userRole');

                    // Navigate to the login screen
                    Navigator.pushReplacementNamed(context, '/login');
                } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Logout failed! ${response.body}')),
                    );
                }
            } else {
                print('No token found in SharedPreferences');
            }
        } catch (error) {
            print("Error during logout: $error");
        }
    }

    Future<void> _loadUserRole() async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        setState(() {
            userRole = prefs.getInt('userRole');
        });
    }

    Future<void> _fetchProfileData() async {
        setState(() {
            isLoading = true;
        });

        try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('authToken');

            if (token != null) {
                final response = await http.get(
                    Uri.parse('http://192.168.8.104:8000/api/artisan/profile'),
                    headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                    },
                );

                if (response.statusCode == 200) {
                    final Map<String, dynamic> profileData = jsonDecode(response.body);

                    Provider.of<ProfileProvider>(context, listen: false)
                        .setArtisanProfile(ArtisanProfile.fromJson(profileData['artisanProfile']));
                    Provider.of<ProfileProvider>(context, listen: false)
                        .setUserProfile(User.fromJson(profileData['user']));
                } else {
                    print('Failed to fetch profile: ${response.statusCode}');
                }
            } else {
                print('No token found in SharedPreferences');
            }
        } catch (error) {
            print("Error fetching profile data: $error");
        } finally {
            setState(() {
                isLoading = false; // Stop loading after fetching data
            });
        }
    }

    @override
    Widget build(BuildContext context) {
        final profileProvider = Provider.of<ProfileProvider>(context);

        return Scaffold(
            appBar: AppBar(
                title: Text('My Profile'),
                backgroundColor: Colors.pink.shade100,
            ),
            body: isLoading
                ? Center(child: CircularProgressIndicator()) // Show a loader until profile data is fetched
                : profileProvider.artisanProfile != null
                ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            _buildProfileHeader(profileProvider),
                            SizedBox(height: 20),
                            _buildProfileDetails(profileProvider),
                            SizedBox(height: 20),
                            _buildEditAndLogoutButtons(profileProvider, context),
                        ],
                    ),
                ),
            )
                : Center(child: Text('Profile not found')),
            bottomNavigationBar: userRole != null
                ? BottomNavBar(currentIndex: 3, userRole: userRole!)
                : SizedBox(),
        );
    }

    // Profile Header with Image and Name
    Widget _buildProfileHeader(ProfileProvider profileProvider) {
        return Row(
            children: [
                CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profileProvider.artisanProfile!.logo!), // Ensure this is a full URL
                ),
                SizedBox(width: 20),
                Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text(
                                profileProvider.user?.name ?? 'No name provided',
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 5),
                            Text(
                                'Artisan',
                                style: TextStyle(
                                    color: Colors.pink.shade400,
                                    fontWeight: FontWeight.w600,
                                ),
                            ),
                        ],
                    ),
                ),
            ],
        );
    }

    // Profile Details with Icons
    Widget _buildProfileDetails(ProfileProvider profileProvider) {
        return Column(
            children: [
                _buildProfileDetail(Icons.info_outline, 'Bio', profileProvider.artisanProfile?.bio ?? 'No bio available'),
                _buildProfileDetail(Icons.phone, 'Contact', profileProvider.artisanProfile?.contactNumber ?? 'No contact available'),
                _buildProfileDetail(Icons.location_city, 'Location', profileProvider.artisanProfile?.city ?? 'No location available'),
                _buildProfileDetail(Icons.timeline, 'Experience', '${profileProvider.artisanProfile?.yearsOfExperience ?? 0} years'),
                _buildProfileDetail(Icons.handyman, 'Skills', profileProvider.artisanProfile?.skills.join(", ") ?? 'No skills listed'),
                _buildProfileDetail(Icons.link, 'Social Media', profileProvider.artisanProfile?.socialMediaLinks ?? 'No social media links'),
                _buildProfileDetail(Icons.map, 'Service Radius', '${profileProvider.artisanProfile?.serviceRadiusKm?.toString() ?? 'No radius provided'} km'),
            ],
        );
    }

    // Build each profile detail with an icon and label
    Widget _buildProfileDetail(IconData icon, String label, String value) {
        return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
                children: [
                    Icon(icon, color: Colors.pink.shade200),
                    SizedBox(width: 10),
                    Text(
                        '$label:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                        ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                        child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade700,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                        ),
                    ),
                ],
            ),
        );
    }

    // Edit and Logout buttons
    Widget _buildEditAndLogoutButtons(ProfileProvider profileProvider, BuildContext context) {
        return Column(
            children: [
                ElevatedButton.icon(
                    onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfileScreen(
                                    profileData: {
                                        'street_address': profileProvider.artisanProfile?.streetAddress,
                                        'city': profileProvider.artisanProfile?.city,
                                        'postal_code': profileProvider.artisanProfile?.postalCode,
                                        'years_of_experience': profileProvider.artisanProfile?.yearsOfExperience,
                                        'bio': profileProvider.artisanProfile?.bio,
                                        'contact_number': profileProvider.artisanProfile?.contactNumber,
                                        'skills': profileProvider.artisanProfile?.skills ?? [],
                                        'social_media_links': profileProvider.artisanProfile?.socialMediaLinks,
                                    },
                                ),
                            ),
                        );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade200,
                    ),
                    icon: Icon(Icons.edit),
                    label: Text('Edit Profile'),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                    onPressed: () => _logout(context),
                    icon: Icon(Icons.logout),
                    label: Text('Logout'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                    ),
                ),
            ],
        );
    }
}
