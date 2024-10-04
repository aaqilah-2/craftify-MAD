import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io'; // For file handling on mobile
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/models/CustomerProfile.dart'; // Ensure you have the correct model

class EditCustomerProfileScreen extends StatefulWidget {
  final CustomerProfile profile; // Pass the existing profile

  EditCustomerProfileScreen({required this.profile});

  @override
  _EditCustomerProfileScreenState createState() => _EditCustomerProfileScreenState();
}

class _EditCustomerProfileScreenState extends State<EditCustomerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the form fields initialized with the existing profile data
  late TextEditingController _streetAddressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneNumberController;

  // Preferences and Payment methods options
  List<String> _preferencesOptions = ['Handcrafted Goods', 'Jewelry', 'Woodwork', 'Textiles', 'Art Pieces'];
  List<String> _paymentMethods = ['Cash', 'Card'];

  List<String> _selectedPreferences = [];
  List<String> _selectedPaymentMethods = [];
  File? _profilePhotoFile;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    // Initialize the controllers with the existing profile data
    _streetAddressController = TextEditingController(text: widget.profile.streetAddress);
    _cityController = TextEditingController(text: widget.profile.city);
    _postalCodeController = TextEditingController(text: widget.profile.postalCode);
    _phoneNumberController = TextEditingController(text: widget.profile.phoneNumber);

    _selectedPreferences = widget.profile.preferences ?? [];
    _selectedPaymentMethods = widget.profile.preferredPaymentMethods ?? [];
  }

  Future<void> _pickProfilePhoto() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _profilePhotoFile = File(pickedFile.path);
      }
    });
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Authorization token not found')),
        );
        return;
      }

      var headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://192.168.8.104:8000/api/customer/profile'), // Use PUT for updating profile
      );

      request.headers.addAll(headers);

      // Add form fields
      request.fields['street_address'] = _streetAddressController.text;
      request.fields['city'] = _cityController.text;
      request.fields['postal_code'] = _postalCodeController.text;
      request.fields['phone_number'] = _phoneNumberController.text;

      // Add preferences
      _selectedPreferences.forEach((preference) {
        request.fields['preferences[]'] = preference;
      });

      // Add payment methods
      if (_selectedPaymentMethods.isNotEmpty) {
        request.fields['preferred_payment_methods'] = jsonEncode(_selectedPaymentMethods);
      }

      // Add profile photo if selected
      if (_profilePhotoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile_photo', _profilePhotoFile!.path),
        );
      }

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          // Success response
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context); // Return to the profile page
        } else {
          // Handle failure
          var responseBody = await http.Response.fromStream(response);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile update failed: ${responseBody.body}')),
          );
        }
      } catch (e) {
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
        title: Text('Edit Profile'),
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
              _buildTextField('Phone Number', _phoneNumberController, keyboardType: TextInputType.phone),

              // Preferences selection
              Column(
                children: _preferencesOptions.map((preference) {
                  return CheckboxListTile(
                    title: Text(preference),
                    value: _selectedPreferences.contains(preference),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedPreferences.add(preference);
                        } else {
                          _selectedPreferences.remove(preference);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              // Payment methods selection
              Column(
                children: _paymentMethods.map((method) {
                  return CheckboxListTile(
                    title: Text(method),
                    value: _selectedPaymentMethods.contains(method),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          _selectedPaymentMethods.add(method);
                        } else {
                          _selectedPaymentMethods.remove(method);
                        }
                      });
                    },
                  );
                }).toList(),
              ),

              // Profile photo selection
              ElevatedButton(
                onPressed: _pickProfilePhoto,
                child: Text(_profilePhotoFile == null ? 'Upload Profile Photo (Optional)' : 'Photo Selected'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                ),
              ),

              // Submit button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Update'),
                        content: Text('Are you sure you want to save these changes?'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Dismiss the dialog
                              _submitForm(); // Call the submit method
                            },
                            child: Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Save Changes'),
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

  // Reusable text field widget
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
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
