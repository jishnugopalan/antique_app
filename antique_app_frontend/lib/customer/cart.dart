import 'dart:convert';

import 'package:antique_app/customer/viewsingleproduct.dart';
import 'package:antique_app/services/productservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  ProductService _productService = ProductService();
  final storage = const FlutterSecureStorage();
  bool isloading = false;
  List<dynamic> _data = [];
  double total = 0;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _houseNameController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _pincodeController = TextEditingController();
  String? shippingid;
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Form is valid, proceed with form submission or further processing
      String fullName = _nameController.text;
      String phone = _phoneController.text;
      String houseName = _houseNameController.text;
      String city = _cityController.text;
      String district = _districtController.text;
      String pincode = _pincodeController.text;

      // TODO: Implement your logic to handle the form submission
      print('Full Name: $fullName');
      print('Phone: $phone');
      print('House Name: $houseName');
      print('City: $city');
      print('District: $district');
      print('Pincode: $pincode');

      Map<String, String> allValues = await storage.readAll();
      String? userid = allValues["userid"];
      var addressdata = jsonEncode({
        "user": userid,
        "fullname": fullName,
        "phone": phone,
        "housename": houseName,
        "city": city,
        "district": district,
        "pincode": pincode
      });

      try {
        final Response res =
            await _productService.addShippingAddress(addressdata);
        print(res.data["_id"]);
        setState(() {
          shippingid = res.data["_id"];
        });
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
      var products = [];
      for (int i = 0; i < _data.length; i++) {
        products.add({
          "product": _data[i]["products"][0]["product"]["_id"],
          "quantity": _data[i]["products"][0]["quantity"]
        });
      }
      print(products);
      var orderdata = jsonEncode({
        "user": userid,
        "products": products,
        "total": total.toInt(),
        "shippingid": shippingid
      });
      try {
        final Response res = await _productService.startOrder(orderdata);
        print(res.data);
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
      Navigator.of(context).pop();
    }
  }

  void _showAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Shipping Address'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Full Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(labelText: 'Phone'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      // Add additional validation rules for phone number, if required
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _houseNameController,
                    decoration: InputDecoration(labelText: 'House Name'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your house name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(labelText: 'City'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your city';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _districtController,
                    decoration: InputDecoration(labelText: 'District'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your district';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Pincode'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your pincode';
                      }
                      // Add additional validation rules for pincode, if required
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                _submitForm();
              },
              child: Text('Order Now'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  deleteCartItem(cartid) async {
    try {
      final Response res = await _productService.deleteCartItem(cartid);
      print(res.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Item deleted"),
        duration: Duration(milliseconds: 300),
      ));
      initState();
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  getCartDetails() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    setState(() {
      isloading = true;
    });
    try {
      final Response res = await _productService.getCartById(userid!);
      // print(res.data);
      num sum = 0;
      for (int i = 0; i < res.data.length; i++) {
        print(res.data[i]["products"][0]["product"]["price"] -
            (res.data[i]["products"][0]["product"]["price"] *
                (res.data[i]["products"][0]["product"]["discount_percentage"] /
                    100.0)));
        sum = sum +
            (res.data[i]["products"][0]["product"]["price"] -
                    (res.data[i]["products"][0]["product"]["price"] *
                        (res.data[i]["products"][0]["product"]
                                ["discount_percentage"] /
                            100.0))) *
                res.data[i]["products"][0]["quantity"];
      }
      print(sum);
      setState(() {
        total = sum.toDouble();
      });
      setState(() {
        isloading = false;
        _data = res.data;
      });
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getCartDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(10),
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        var price = _data[index]["products"][0]["product"]
                                ["price"] -
                            (_data[index]["products"][0]["product"]["price"] *
                                (_data[index]["products"][0]["product"]
                                        ["discount_percentage"] /
                                    100.0));
                        var quantity = _data[index]["products"][0]["quantity"];
                        var total_price = price * quantity;

                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ViewSingleProduct(
                                          productid: _data[index]["products"][0]
                                              ["product"]["_id"],
                                        )));
                          },
                          title: Text(_data[index]["products"][0]["product"]
                              ["productname"]),
                          subtitle: Text(
                              "Items ${_data[index]["products"][0]["quantity"]}\n₹$total_price"),
                          leading: Image.memory(
                            base64Decode(_data[index]["products"][0]["product"]
                                    ["image"]
                                .split(',')[1]),
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(Icons.image);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_shopping_cart,
                              color: Colors.purple,
                              size: 30,
                            ),
                            onPressed: () {
                              deleteCartItem(_data[index]["_id"]);
                            },
                          ),
                        );
                      }),
                ],
              ),
        bottomNavigationBar: total != 0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    child: SubHeadingText(
                        text: "Total :₹" + total.toInt().toString(),
                        align: TextAlign.center,
                        color: Colors.black),
                  ),
                  Container(
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                          onPressed: () {
                            _showAddressDialog();
                          },
                          child: const Text("Order Now")))
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_shopping_cart_outlined,
                    size: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: const Text(
                      "Your cart is empty",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ));
  }
}
