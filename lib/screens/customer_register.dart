import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io'; // For file handling on mobile
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart'; // For token storage


class CustomerProfileForm extends StatefulWidget {
  @override
  _CustomerProfileFormState createState() => _CustomerProfileFormState();
}

class _CustomerProfileFormState extends State<CustomerProfileForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the fields
  TextEditingController _streetAddressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  // Preferences list (for multiple selection)
  final List<String> _preferencesOptions = ['Handcrafted Goods', 'Jewelry', 'Woodwork', 'Textiles', 'Art Pieces'];
  List<String> _selectedPreferences = []; // To store selected preferences

  // Payment methods (for single or multiple selection)
  final List<String> _paymentMethods = ['Cash', 'Card'];
  List<String> _selectedPaymentMethods = []; // To store selected payment methods (can be multiple)

  // For file upload (optional)
  File? _profilePhotoFile;
  final picker = ImagePicker();

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
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.186.77:8000/api/customer/profile'),
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

      // Add payment methods (encoded as JSON array)
      if (_selectedPaymentMethods.isNotEmpty) {
        request.fields['preferred_payment_methods'] = jsonEncode(_selectedPaymentMethods); // Send as JSON array
      }

      // Add profile photo if selected
      if (_profilePhotoFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile_photo', _profilePhotoFile!.path),
        );
      }

      try {
        var response = await request.send();

        if (response.statusCode == 201) {
          print("Profile created successfully, redirecting to /home");
          Navigator.pushReplacementNamed(context, '/home');
        }
        else {
          // Handle failure response
          var responseBody = await http.Response.fromStream(response);
          print("Failed Status Code: ${response.statusCode}");
          print("Response Body: ${responseBody.body}");

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile creation failed: ${responseBody.body}')),
          );
        }
      } catch (e) {
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
        title: Text('Create Customer Profile'),
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

              // Preferences Checkbox List
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferences *', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._preferencesOptions.map((preference) {
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
                  ],
                ),
              ),

              // Payment Method Checkbox List (Optional)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferred Payment Methods (Optional)', style: TextStyle(fontWeight: FontWeight.bold)),
                    ..._paymentMethods.map((method) {
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
                  ],
                ),
              ),

              ElevatedButton(
                onPressed: _pickProfilePhoto,
                child: Text(_profilePhotoFile == null ? 'Upload Profile Photo (Optional)' : 'Photo Selected'),
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

  // Reusable text field builder
  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: '$label *', // Required field
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
