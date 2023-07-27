import 'dart:convert';

import 'package:antique_app/shop/viewmyproduct.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../services/productservice.dart';
import '../widgets/text_widgets.dart';

class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key, required this.productid});
  final String productid;

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  ProductService service = ProductService();
  final _formkey1 = GlobalKey<FormState>();
  final _formkey2 = GlobalKey<FormState>();
  final _formkey3 = GlobalKey<FormState>();
  final _formkey4 = GlobalKey<FormState>();

  final TextEditingController _price = TextEditingController();
  String price = "";
  final TextEditingController _discount = TextEditingController();
  String discount = "";
  final TextEditingController _stock = TextEditingController();
  String stock = "";
  final TextEditingController _availability = TextEditingController();
  String? selectedStatus;

  final List<String> availabilityStatuses = [
    'Available',
    'In Stock',
    'Out of Stock',
    'Limited Stock',
  ];

  dynamic _data;
  bool isLoading = false;
  getProductDetails(id) async {
    setState(() {
      isLoading = true;
    });
    try {
      final Response res = await service.getProductByProductid(id);
      setState(() {
        _data = res.data;
        isLoading = false;
        _price.text = res.data["price"].toString();
        _stock.text = res.data["stock"].toString();
        _discount.text = res.data["discount_percentage"].toString();
        selectedStatus = res.data["availability"];
      });
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getProductDetails(widget.productid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Update Product"),
        ),
        body: isLoading
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
                  // SubHeadingText(
                  //     text: "Category: " + _data["category"]["category"],
                  //     align: TextAlign.center,
                  //     color: Colors.black),
                  // Container(
                  //   padding: const EdgeInsets.only(bottom: 20),
                  //   child: SubHeadingText(
                  //       text: "Subcategory: " +
                  //           _data["subcategory"]["subcategory"],
                  //       align: TextAlign.center,
                  //       color: Colors.black),
                  // ),
                  Text(
                    "Price: ₹ ${_data["price"]}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Form(
                      key: _formkey1,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Price"),
                            controller: _price,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Price is required";
                              } else if (int.parse(value) <= 0) {
                                return "Please enter a valid price";
                              }
                              setState(() {
                                price = value;
                              });
                              return null;
                            },
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         if (_formkey1.currentState!.validate()) {
                          //           print(price);
                          //         }
                          //       },
                          //       child: const Text("Update")),
                          // )
                        ],
                      )),

                  Text(
                    "Discount Percentage: ${_data["discount_percentage"]}%",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Form(
                      key: _formkey2,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(
                                labelText: "Discount Percentage"),
                            controller: _discount,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Discount Percentage is required";
                              } else if (int.parse(value) <= 0) {
                                return "Please enter a valid discount";
                              }
                              setState(() {
                                discount = value;
                              });
                              return null;
                            },
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         if (_formkey2.currentState!.validate()) {
                          //           print(discount);
                          //         }
                          //       },
                          //       child: const Text("Update")),
                          // )
                        ],
                      )),
                  Text(
                    "Stock: ${_data["stock"]}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Form(
                      key: _formkey3,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: "Stock"),
                            controller: _stock,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Stock is required";
                              } else if (int.parse(value) <= 0) {
                                return "Please enter a valid stock";
                              }
                              setState(() {
                                stock = value;
                              });
                              return null;
                            },
                          ),
                          // Container(
                          //   alignment: Alignment.center,
                          //   child: ElevatedButton(
                          //       onPressed: () {
                          //         if (_formkey3.currentState!.validate()) {
                          //           print(stock);
                          //         }
                          //       },
                          //       child: const Text("Update")),
                          // )
                        ],
                      )),

                  Text(
                    "Available Status: ${_data["availability"]}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  Form(
                    key: _formkey4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Text(
                        //   'Select Availability Status:',
                        //   style: TextStyle(
                        //     fontSize: 16.0,
                        //     fontWeight: FontWeight.bold,
                        //   ),
                        // ),

                        DropdownButtonFormField<String>(
                          value: selectedStatus,
                          onChanged: (newValue) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                          },
                          items: availabilityStatuses.map((status) {
                            return DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            //filled: true,
                            //fillColor: Colors.grey[200],
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (_formkey1.currentState!.validate() &&
                              _formkey2.currentState!.validate() &&
                              _formkey3.currentState!.validate() &&
                              _formkey4.currentState!.validate()) {
                            print("$price $stock $discount");
                            try {
                              final Response res1 = await service
                                  .updateProductPrice(widget.productid, price);
                              final Response res2 =
                                  await service.updateProductDiscount(
                                      widget.productid, discount);
                              final Response res3 = await service
                                  .updateProductStock(widget.productid, stock);
                              final Response res4 =
                                  await service.updateProductAvailability(
                                      widget.productid,
                                      selectedStatus.toString());
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Updated Successfully"),
                                duration: Duration(milliseconds: 300),
                              ));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateProduct(
                                        productid: widget.productid),
                                  ));
                            } on DioException catch (e) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content:
                                    Text("Error occurred,please try again"),
                                duration: Duration(milliseconds: 300),
                              ));
                            }
                          }
                        },
                        child: Text("Update")),
                  )
                ],
              ));
  }
}
