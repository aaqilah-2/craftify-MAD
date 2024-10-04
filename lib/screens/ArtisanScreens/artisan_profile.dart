import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // This is required for using Provider
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
            // Get the stored token
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('authToken');

            if (token != null) {
                // Make the API call to the logout route
                final response = await http.post(
                    Uri.parse('http://192.168.8.104:8000/api/logout'), // Your logout API URL
                    headers: {
                        'Authorization': 'Bearer $token',
                        'Content-Type': 'application/json',
                    },
                );

                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');

                if (response.statusCode == 200) {
                    // Logout successful
                    print('Logout successful');
                    // Remove the token from SharedPreferences
                    await prefs.remove('authToken');
                    await prefs.remove('userRole');

                    // Navigate to the login screen
                    Navigator.pushReplacementNamed(context, '/login');
                } else {
                    // Show an error message if logout fails
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
            userRole = prefs.getInt('userRole'); // Retrieve the user role stored in SharedPreferences
        });
    }

    Future<void> _fetchProfileData() async {
        setState(() {
            isLoading = true;
        });

        try {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? token = prefs.getString('authToken'); // Ensure the correct token is retrieved

            if (token != null) {
                final response = await http.get(
                    Uri.parse('http://192.168.8.104:8000/api/artisan/profile'),
                    headers: {
                        'Authorization': 'Bearer $token', // Send token in Authorization header
                        'Content-Type': 'application/json',
                    },
                );

                if (response.statusCode == 200) {
                    final Map<String, dynamic> profileData = jsonDecode(response.body);
                    print('Profile data received: $profileData');

                    // Set the profile data correctly in the provider
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
                isLoading = false;  // Stop loading after fetching data
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
                            CircleAvatar(
                                radius: 50,
                                backgroundImage: NetworkImage(profileProvider.artisanProfile!.logo!), // Ensure this is a full URL
                            ),
                            SizedBox(height: 20),
                            Text(
                                profileProvider.user?.name ?? 'No name provided', // Display the artisan's name
                                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            Text('Bio: ${profileProvider.artisanProfile?.bio ?? 'No bio available'}'),
                            SizedBox(height: 10),
                            Text('Contact: ${profileProvider.artisanProfile?.contactNumber ?? 'No contact available'}'),
                            SizedBox(height: 10),
                            Text('Location: ${profileProvider.artisanProfile?.city ?? 'No location available'}'),
                            SizedBox(height: 10),
                            Text('Years of Experience: ${profileProvider.artisanProfile?.yearsOfExperience ?? 0}'),
                            SizedBox(height: 10),
                            Text('Skills: ${profileProvider.artisanProfile?.skills.join(", ") ?? 'No skills listed'}'),
                            SizedBox(height: 10),
                            Text('Social Media: ${profileProvider.artisanProfile?.socialMediaLinks ?? 'No social media links'}'),
                            SizedBox(height: 10),
                            Text('Service Radius: ${profileProvider.artisanProfile?.serviceRadiusKm?.toString() ?? 'No radius provided'} km'),
                            SizedBox(height: 20),
                            ElevatedButton(
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
                                child: Text('Edit Profile'),
                            ),
                            // Logout Button
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
                    ),
                ),
            )
                : Center(child: Text('Profile not found')), // Fallback if no profile is loaded
            bottomNavigationBar: userRole != null
                ? BottomNavBar(currentIndex: 3, userRole: userRole!) // Pass the correct userRole to the BottomNavBar
                : SizedBox(), // Display nothing until the userRole is loaded
        );
    }
}