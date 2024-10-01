import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // Use dart:io for file handling
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For token storage

class ArtisanProfileForm extends StatefulWidget {
  @override
  _ArtisanProfileFormState createState() => _ArtisanProfileFormState();
}

class _ArtisanProfileFormState extends State<ArtisanProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the fields
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _yearsOfExperienceController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _serviceRadiusController = TextEditingController();
  TextEditingController _socialMediaController = TextEditingController();

  // For skills selection
  List<String> _selectedSkills = [];
  final List<String> _skills = ['Woodworking', 'Metalworking', 'Pottery', 'Jewelry', 'Painting', 'Textiles', 'Other'];

  // For file upload (dart:io)
  File? _logoFile;
  final picker = ImagePicker();

  Future<void> _pickLogo() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _logoFile = File(pickedFile.path); // Store the file for mobile use
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Retrieve the token from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('auth_token');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authorization token not found')),
        );
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token', // Use the retrieved token
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.8.101:8000/api/artisan/profile'), // Update the URL
      );

      request.headers.addAll(headers);  // Add headers to the request

      // Add form fields
      request.fields['street_address'] = _streetAddressController.text;
      request.fields['city'] = _cityController.text;
      request.fields['postal_code'] = _postalCodeController.text;
      request.fields['years_of_experience'] = _yearsOfExperienceController.text;
      request.fields['skills'] = jsonEncode(_selectedSkills);
      request.fields['bio'] = _bioController.text;
      request.fields['contact_number'] = _contactNumberController.text;
      request.fields['service_radius_km'] = _serviceRadiusController.text;
      request.fields['social_media_links'] = _socialMediaController.text;

      // Add file if present
      if (_logoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('logo', _logoFile!.path),
        );
      }

      try {
        var response = await request.send();

        if (response.statusCode == 201) {
          // Profile created successfully, navigate to the Artisan Home Screen
          Navigator.pushReplacementNamed(context, '/artisan_home');
        } else {
          // If the response status is not 201, show the response message for debugging
          var responseBody = await http.Response.fromStream(response);
          print("Failed Status Code: ${response.statusCode}");
          print("Response Body: ${responseBody.body}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile creation failed. ${responseBody.body}')),
          );
        }
      } catch (e) {
        // Handle network or request errors
        print("Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Artisan Profile'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              _buildTextField('Street Address', _streetAddressController),
              _buildTextField('City', _cityController),
              _buildTextField('Postal Code', _postalCodeController),
              _buildTextField('Years of Experience', _yearsOfExperienceController, keyboardType: TextInputType.number),
              _buildTextField('Skills (Other)', TextEditingController()),

              // Skills Checkbox List
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _skills.map((skill) {
                  return CheckboxListTile(
                    title: Text(skill),
                    value: _selectedSkills.contains(skill),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedSkills.add(skill);
                        } else {
                          _selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              _buildTextField('Bio', _bioController, maxLines: 3),
              _buildTextField('Contact Number', _contactNumberController, keyboardType: TextInputType.phone),
              _buildTextField('Service Radius (in km)', _serviceRadiusController),

              // Social Media Links
              _buildTextField('Social Media Links (Optional)', _socialMediaController),

              ElevatedButton(
                onPressed: _pickLogo,
                child: Text(_logoFile == null ? 'Upload Logo *' : 'Logo Selected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade200,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
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
