import 'package:flutter/material.dart';
import 'package:craftify/models/CustomerProfile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class EditCustomerProfileScreen extends StatefulWidget {
  final CustomerProfile profile;

  EditCustomerProfileScreen({required this.profile});

  @override
  _EditCustomerProfileScreenState createState() => _EditCustomerProfileScreenState();
}

class _EditCustomerProfileScreenState extends State<EditCustomerProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for the text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _cityController;
  late TextEditingController _streetController;
  late TextEditingController _phoneController;
  late TextEditingController _postalCodeController;

  // Preferences and Payment methods (multi-select options)
  List<String> _preferencesOptions = ['Handcrafted Goods', 'Jewelry', 'Woodwork', 'Textiles', 'Art Pieces'];
  List<String> _paymentMethodsOptions = ['Cash', 'Card'];

  List<String> _selectedPreferences = [];
  List<String> _selectedPaymentMethods = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing profile data
    _nameController = TextEditingController(text: widget.profile.name);
    _emailController = TextEditingController(text: widget.profile.email);
    _cityController = TextEditingController(text: widget.profile.city);
    _streetController = TextEditingController(text: widget.profile.streetAddress);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _postalCodeController = TextEditingController(text: widget.profile.postalCode);

    // Initialize preferences and payment methods
    _selectedPreferences = widget.profile.preferences ?? [];
    _selectedPaymentMethods = widget.profile.preferredPaymentMethods ?? [];
  }

  Future<void> _submitProfile() async {
    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) return;

      final url = 'http://192.168.8.104:8000/api/customer/profile';
      final response = await http.put(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'city': _cityController.text,
          'street_address': _streetController.text,
          'phone_number': _phoneController.text,
          'postal_code': _postalCodeController.text,
          'preferences': _selectedPreferences,
          'preferred_payment_methods': _selectedPaymentMethods,
        }),
      );

      if (response.statusCode == 200) {
        // Profile updated, navigate back
        Navigator.pop(context);
      } else {
        print('Failed to update profile');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Please enter your name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter your email' : null,
              ),
              TextFormField(
                controller: _cityController,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => value!.isEmpty ? 'Please enter a city' : null,
              ),
              TextFormField(
                controller: _streetController,
                decoration: InputDecoration(labelText: 'Street Address'),
                validator: (value) => value!.isEmpty ? 'Please enter a street address' : null,
              ),
              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code'),
                validator: (value) => value!.isEmpty ? 'Please enter your postal code' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value!.isEmpty ? 'Please enter a phone number' : null,
              ),

              // Preferences selection
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Preferences', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
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

              // Payment methods selection
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text('Preferred Payment Methods', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ..._paymentMethodsOptions.map((method) {
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

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitProfile,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
