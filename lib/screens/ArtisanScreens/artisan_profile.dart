import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // This is required for using Provider
import 'package:craftify/providers/ProfileProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:craftify/widgets/bottom_nav_bar.dart';


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
    _loadUserRole();  // Fetch the stored user role
    _fetchProfileData();  // Fetch the profile data from the server
  }

  Future<void> _loadUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole');  // Retrieve the user role stored in SharedPreferences
    });
  }

  Future<void> _fetchProfileData() async {
    try {
      await Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    } catch (error) {
      // Handle error gracefully (if needed)
      print("Error fetching profile data: $error");
    } finally {
      setState(() {
        isLoading = false;  // Ensure the loading state is updated even if there's an error
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
          ? Center(child: CircularProgressIndicator())  // Show a loader until profile data is fetched
          : profileProvider.artisanProfile != null
          ? Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(profileProvider.artisanProfile!.logo),  // Logo should always be present
              ),
              SizedBox(height: 20),
              Text(
                profileProvider.user?.name ?? 'No name provided',  // Display the artisan's name
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
                  // Navigate to edit profile screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade200,
                ),
                child: Text('Edit Profile'),
              ),
            ],
          ),
        ),
      )
          : Center(child: Text('Profile not found')),  // Fallback if no profile is loaded
      bottomNavigationBar: userRole != null
          ? BottomNavBar(currentIndex: 3, userRole: userRole!)  // Pass the correct userRole to the BottomNavBar
          : SizedBox(),  // Display nothing until the userRole is loaded
    );
  }
}
