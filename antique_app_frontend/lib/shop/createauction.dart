import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AuctionForm extends StatefulWidget {
  const AuctionForm({super.key});

  @override
  _AuctionFormState createState() => _AuctionFormState();
}

class _AuctionFormState extends State<AuctionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _productName = '';
  String _description = '';
  double _initialAmount = 0.0;
  String _auctionStatus = 'Active';
  XFile? _imageFile;
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Perform form submission logic here
      print('Form submitted');
    }
  }

  Future<void> getImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = image;
    });
  }

  Future<void> getImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      const Text("Select Product image"),
                      IconButton(
                          onPressed: getImageFromCamera,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.blue,
                          )),
                      IconButton(
                          onPressed: getImageFromGallery,
                          icon: const Icon(
                            Icons.image,
                            color: Colors.blue,
                          ))
                    ],
                  ),
                ),
                Container(
                  child: Card(
                    child: _imageFile == null
                        ? const Text('No image selected ')
                        : Image.file(
                            File(_imageFile!.path),
                            width: 360,
                            height: 240,
                          ),
                  ),
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Auction Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _productName = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _description = value!;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Initial Amount'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an initial amount';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _initialAmount = double.parse(value!);
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Auction Status'),
                  value: _auctionStatus,
                  items: <String>['Active', 'Inactive'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _auctionStatus = newValue!;
                    });
                  },
                  onSaved: (String? value) {
                    _auctionStatus = value!;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
