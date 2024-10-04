import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart'; // Import permission handler
import 'package:craftify/widgets/bottom_nav_bar.dart'; // Import the BottomNavBar
import 'package:image/image.dart' as img; // Add this for resizing image if needed

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
  String? _selectedCategory; // For dropdown category selection
  bool _isLoading = false;
  int userRole = 0; // Variable to hold the role value

  // List of categories for dropdown
  final List<String> _categories = [
    'Jewelry',
    'Clothing',
    'Home Decor',
    'Art & Collectibles',
    'Toys',
    'Craft Supplies',
    'Accessories',
    'Stationery',
    'Bags & Purses',
    'Other'  // Include "Other" at the end
  ];

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

  // Method to pick an image from gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      if (await Permission.camera.request().isGranted) {
        final pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          _processPickedImage(File(pickedFile.path));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera permission denied')),
        );
      }
    } else {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        _processPickedImage(File(pickedFile.path));
      }
    }
  }

  // Process image and reduce size if necessary
  Future<void> _processPickedImage(File imageFile) async {
    // Resize the image if it's too large
    final originalImage = img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage != null && originalImage.width > 1024) {
      final resizedImage = img.copyResize(originalImage, width: 1024); // Resize to 1024px wide
      final directory = await getTemporaryDirectory();
      final String newPath = '${directory.path}/${DateTime.now().toIso8601String()}.jpg';
      final resizedFile = File(newPath)..writeAsBytesSync(img.encodeJpg(resizedImage));
      setState(() {
        _image = resizedFile; // Use the resized image
      });
    } else {
      setState(() {
        _image = imageFile; // Use the original image if not large
      });
    }
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
          Uri.parse('http://192.168.8.104:8000/api/products'), // Update with your API URL
        );
        request.headers['Authorization'] = 'Bearer $token';
        request.fields['name'] = _nameController.text;
        request.fields['description'] = _descriptionController.text;
        request.fields['price'] = _priceController.text;
        request.fields['category'] = _selectedCategory!; // Use selected category

        request.files.add(await http.MultipartFile.fromPath(
          'image',
          _image!.path,
          contentType: MediaType('image', 'jpeg'),
        ));

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

                // Dropdown for category selection
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(labelText: 'Category'),
                  items: _categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? 'Select a category' : null,
                ),

                SizedBox(height: 20),
                _image != null
                    ? Image.file(_image!, height: 150)
                    : Text('No image selected'),
                SizedBox(height: 20),

                // Button to select image source (gallery or camera)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.gallery),
                      child: Text('Select from Gallery'),
                    ),
                    ElevatedButton(
                      onPressed: () => _pickImage(ImageSource.camera),
                      child: Text('Take a Picture'),
                    ),
                  ],
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

      // Bottom Navigation Bar remains unchanged
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2, // Assuming Orders is at index 3 for Artisan
        userRole: userRole, // Use the retrieved user role dynamically
      ),
    );
  }
}
