import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData; // Pass profile data to pre-fill the form

  EditProfileScreen({required this.profileData});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _streetAddressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _yearsOfExperienceController;
  late TextEditingController _bioController;
  late TextEditingController _contactNumberController;
  late TextEditingController _skillsController;
  late TextEditingController _socialMediaLinksController;

  @override
  void initState() {
    super.initState();
    // Initialize the text controllers with profile data
    _streetAddressController = TextEditingController(text: widget.profileData['street_address']);
    _cityController = TextEditingController(text: widget.profileData['city']);
    _postalCodeController = TextEditingController(text: widget.profileData['postal_code']);
    _yearsOfExperienceController = TextEditingController(text: widget.profileData['years_of_experience'].toString());
    _bioController = TextEditingController(text: widget.profileData['bio']);
    _contactNumberController = TextEditingController(text: widget.profileData['contact_number']);
    _skillsController = TextEditingController(text: widget.profileData['skills'].join(', '));
    _socialMediaLinksController = TextEditingController(text: widget.profileData['social_media_links'] ?? '');
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Save the updated profile to the backend
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');
      if (token == null) {
        throw Exception("No token found");
      }

      final url = 'http://192.168.8.101:8000/api/artisan/profile';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'street_address': _streetAddressController.text,
          'city': _cityController.text,
          'postal_code': _postalCodeController.text,
          'years_of_experience': int.parse(_yearsOfExperienceController.text),
          'bio': _bioController.text,
          'contact_number': _contactNumberController.text,
          'skills': _skillsController.text.split(', ').map((skill) => skill.trim()).toList(),
          'social_media_links': _socialMediaLinksController.text,
        }),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);  // Go back to profile screen after successful update
      } else {
        // Handle errors here
        print("Failed to update profile: ${response.body}");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Street Address', _streetAddressController),
                _buildTextField('City', _cityController),
                _buildTextField('Postal Code', _postalCodeController),
                _buildTextField('Years of Experience', _yearsOfExperienceController, keyboardType: TextInputType.number),
                _buildTextField('Bio', _bioController, maxLines: 3),
                _buildTextField('Contact Number', _contactNumberController, keyboardType: TextInputType.phone),
                _buildTextField('Skills (comma-separated)', _skillsController),
                _buildTextField('Social Media Links', _socialMediaLinksController),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: '$label *',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label is required';
          }
          return null;
        },
      ),
    );
  }
}
