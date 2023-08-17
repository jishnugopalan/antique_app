import 'dart:convert';
import 'dart:io';

import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';

class AuctionForm extends StatefulWidget {
  const AuctionForm({super.key});

  @override
  _AuctionFormState createState() => _AuctionFormState();
}

class _AuctionFormState extends State<AuctionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final storage = const FlutterSecureStorage();
  ShopService _service = ShopService();
  bool isloading = false;
  TextEditingController _productName = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _initialAmount = TextEditingController();
  String _auctionStatus = 'Active';
  XFile? _imageFile;
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Perform form submission logic here
      if (mounted) {
        setState(() {
          isloading = true;
        });
      }
      print('Form submitted');
      List<String>? s = _imageFile?.path.toString().split("/");
      final bytes = await File(_imageFile!.path).readAsBytes();
      final base64 = base64Encode(bytes);
      var pic =
          "data:image/" + s![s.length - 1].split(".")[1] + ";base64," + base64;

      Map<String, String> allValues = await storage.readAll();
      String? userid = allValues["userid"];
      String shopid = "";
      try {
        final Response? response3 = await _service.getShopByUserId(userid!);
        shopid = response3!.data["_id"];
      } on DioException catch (e) {
        if (e.response != null) {
          // print(e.response!.data);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error occurred,please try again 1"),
            duration: Duration(milliseconds: 300),
          ));
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error occurred,please try again 2"),
            duration: Duration(milliseconds: 300),
          ));
        }
      }
      print(shopid);
      var details = jsonEncode({
        "shop": shopid,
        "productname": _productName.text,
        "image": pic,
        "description": _description.text,
        "availability": _auctionStatus,
        "price": _initialAmount.text
      });
      print(details);
      try {
        final Response res = await _service.addAuctionItem(details);
        print(res.data);
        if (mounted) {
          setState(() {
            isloading = false;
          });
        }
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Auction Added"),
                content: Text("Auction added successfully"),
                actions: [
                  TextButton(
                    child: Text("Ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } on DioException catch (e) {
        setState(() {
          isloading = false;
        });
        print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again 3"),
          duration: Duration(milliseconds: 300),
        ));
      }
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
                  controller: _productName,
                  decoration:
                      InputDecoration(labelText: 'Auction Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
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
                  controller: _description,
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
                  controller: _initialAmount,
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
