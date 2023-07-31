import 'dart:convert';
import 'dart:ffi';

import 'package:antique_app/services/productservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../widgets/text_widgets.dart';

class ViewSingleProduct extends StatefulWidget {
  const ViewSingleProduct({super.key, required this.productid});
  final String productid;

  @override
  State<ViewSingleProduct> createState() => _ViewSingleProductState();
}

class _ViewSingleProductState extends State<ViewSingleProduct> {
  ProductService _productService = ProductService();
  dynamic _data;
  bool isloading = false;
  int _quantity = 1;
  double total_price = 0;
  double price = 0;
  final storage = const FlutterSecureStorage();
  @override
  getProductDetails() async {
    setState(() {
      isloading = true;
    });
    try {
      final Response res =
          await _productService.getProductByProductid(widget.productid);
      setState(() {
        isloading = false;
        _data = res.data;
        price = res.data["price"] -
            (_data["price"] * (_data["discount_percentage"] / 100.0));
        total_price = price * _quantity;
      });
      print(res);
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

  void initState() {
    // TODO: implement initState
    print(widget.productid);
    getProductDetails();
    super.initState();
  }

  addToCart(productid, quantity) async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    var cartdata = jsonEncode({
      "user": userid,
      "products": [
        {"product": productid, "quantity": _quantity}
      ]
    });
    print(cartdata);

    try {
      final Response res = await _productService.addToCart(cartdata);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Item added to cart"),
        duration: Duration(milliseconds: 1000),
      ));
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  getQuantityDetails(productid) {
    showDialog(
      context: context,
      builder: (context) {
        String contentText = "Content of Dialog";
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Enter Quantity'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Please enter the desired quantity:'),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_quantity > 1) {
                            setState(() {
                              _quantity--;
                              total_price = price * _quantity;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('$_quantity'),
                      IconButton(
                        onPressed: () {
                          if (_quantity < 5) {
                            setState(() {
                              _quantity++;
                              total_price = price * _quantity;
                            });
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  Text("₹" + total_price.toString())
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    addToCart(productid, _quantity);
                  },
                  child: Text('Add to Cart'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: isloading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.only(left: 10, bottom: 20, right: 10),
                children: [
                  Card(
                    child: Image.memory(
                      base64Decode(_data["image"].split(',')[1]),
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(Icons.image);
                      },
                    ),
                  ),
                  HeadingText(
                      text: _data["productname"],
                      align: TextAlign.center,
                      color: Colors.black),
                  DescriptionText(
                      text: "Category: " + _data["category"]["category"],
                      align: TextAlign.left,
                      color: Colors.black),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: DescriptionText(
                        text: "Subcategory: " +
                            _data["subcategory"]["subcategory"],
                        align: TextAlign.left,
                        color: Colors.black),
                  ),
                  Row(
                    children: [
                      Text(
                        "₹ ${_data["price"]}",
                        style: const TextStyle(
                            fontSize: 18,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      SubHeadingText(
                          text:
                              "₹${_data["price"] - (_data["price"] * (_data["discount_percentage"] / 100.0))}",
                          align: TextAlign.justify,
                          color: Colors.black),
                      const SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.green,
                        child: Text(
                          "${_data["discount_percentage"]}% Off",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: DescriptionText(
                        text: _data["description"],
                        align: TextAlign.justify,
                        color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: DescriptionText(
                        text: "Shop Name :" + _data["shop"]["shopname"],
                        align: TextAlign.justify,
                        color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: DescriptionText(
                        text: "Address" +
                            "\n" +
                            _data["shop"]["shopcity"] +
                            "\n" +
                            _data["shop"]["shopdistrict"] +
                            "\n" +
                            "Pincode :" +
                            _data["shop"]["shoppincode"] +
                            "\n" +
                            "Phone :" +
                            _data["shop"]["shopphone"].toString() +
                            "\n" +
                            "Email :" +
                            _data["shop"]["shopemail"],
                        align: TextAlign.justify,
                        color: Colors.black),
                  ),
                  if (_data["availability"] == "In Stock" ||
                      _data["availability"] == "Available") ...[
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: DescriptionText(
                          text: "Stock Status: " + _data["availability"],
                          align: TextAlign.justify,
                          color: Colors.green),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue),
                          onPressed: () {
                            getQuantityDetails(_data["_id"]);
                          },
                          child: const Text("Add to Cart")),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.yellow),
                          onPressed: () {},
                          child: const Text(
                            "Buy Now",
                            style: TextStyle(color: Colors.black),
                          )),
                    )
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.only(top: 20),
                      child: DescriptionText(
                          text: "Stock Status: " + _data["availability"],
                          align: TextAlign.justify,
                          color: Colors.red),
                    ),
                  ]
                ],
              ));
  }
}
