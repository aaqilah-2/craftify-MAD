import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:craftify/widgets/bottom_nav_bar.dart'; // Import the BottomNavBar

class UploadProductScreen extends StatefulWidget {
  @override
  _UploadProductScreenState createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  bool _isLoading = false;
  int userRole = 0; // Variable to hold the role value

  @override
  void initState() {
    super.initState();
    _getUserRole(); // Fetch user role when the screen loads
  }

  Future<void> _getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userRole = prefs.getInt('userRole') ?? 0; // Assuming userRole is stored as an int in SharedPreferences
    });
    print('Retrieved User Role: $userRole'); // Debugging user role retrieval
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _uploadProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select an image'),
        ));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No token found, please login first'),
        ));
        setState(() {
          _isLoading = false;
        });
        return;
      }

      print('Retrieved Token: $token'); // Debugging token retrieval

      try {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.8.101:8000/api/products'), // Update with your API URL
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['name'] = _nameController.text;
        request.fields['description'] = _descriptionController.text;
        request.fields['price'] = _priceController.text;
        request.fields['category'] = _categoryController.text;

        request.files.add(await http.MultipartFile.fromPath('image', _image!.path));

        final response = await request.send();

        setState(() {
          _isLoading = false;
        });

        if (response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Product uploaded successfully'),
          ));
          Navigator.pop(context); // Go back after success
        } else {
          String responseBody = await response.stream.bytesToString();
          print('Upload failed: Status code ${response.statusCode}, Response: $responseBody'); // Debugging failed upload
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to upload product: ${response.statusCode}'),
          ));
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Upload error: $e'); // Debugging any exceptions
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('An error occurred: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Upload Product')),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter product name' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter description' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                  value!.isEmpty ? 'Enter price' : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                  validator: (value) =>
                  value!.isEmpty ? 'Enter category' : null,
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(_image!, height: 150)
                    : Text('No image selected'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _uploadProduct,
                  child: Text('Upload Product'),
                ),
              ],
            ),
          ),
        ),
      ),
      // Add the BottomNavBar with the userRole from SharedPreferences
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Assuming Orders is at index 3 for Artisan
        userRole: userRole, // Use the retrieved user role dynamically
      ),
    );
  }
}
