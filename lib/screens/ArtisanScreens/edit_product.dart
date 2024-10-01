import 'package:flutter/material.dart';
import 'package:craftify/models/product.dart';
import 'package:provider/provider.dart';
import 'package:craftify/providers/product_provider.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _category;
  late double _price;

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _description = widget.product.description;
    _price = widget.product.price;
    _category = widget.product.category;
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Save Changes'),
        content: Text('Are you sure you want to save the changes?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _saveChanges();
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final updatedData = {
        'name': _name,
        'description': _description,
        'price': _price,
        'category': _category,
      };
      Provider.of<ProductProvider>(context, listen: false)
          .updateProduct(widget.product.id, updatedData);
      Navigator.pop(context); // Close the screen after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        backgroundColor: Colors.pink.shade100,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Image Box with pink theme and shadow
              Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: widget.product.imageUrl.isNotEmpty
                    ? Image.network(
                  widget.product.imageUrl, // Fetch image from API response
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.contain, // Use BoxFit.contain to ensure no overflow
                )
                    : Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey,
                  child: Icon(Icons.image, size: 50, color: Colors.white),
                ),
              ),

              // Form inside a styled card
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          filled: true,
                          fillColor: Colors.pink.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (value) => _name = value!,
                        validator: (value) {
                          if (value!.isEmpty) return 'Please enter a name';
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          filled: true,
                          fillColor: Colors.pink.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (value) => _description = value!,
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _price.toString(),
                        decoration: InputDecoration(
                          labelText: 'Price',
                          filled: true,
                          fillColor: Colors.pink.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) => _price = double.parse(value!),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        initialValue: _category,
                        decoration: InputDecoration(
                          labelText: 'Category',
                          filled: true,
                          fillColor: Colors.pink.shade50,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onSaved: (value) => _category = value!,
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          // Show confirmation dialog before saving changes
                          _showConfirmationDialog(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink.shade200, // Button color
                          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
