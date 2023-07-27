import 'dart:convert';
import 'dart:developer';

import 'package:antique_app/services/productservice.dart';
import 'package:antique_app/shop/updateproduct.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewShopProduct extends StatefulWidget {
  const ViewShopProduct({super.key, required this.productid});
  final String productid;

  @override
  State<ViewShopProduct> createState() => _ViewShopProductState();
}

class _ViewShopProductState extends State<ViewShopProduct> {
  ProductService service = ProductService();
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
        appBar: AppBar(),
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
                  SubHeadingText(
                      text: "Category: " + _data["category"]["category"],
                      align: TextAlign.center,
                      color: Colors.black),
                  Container(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: SubHeadingText(
                        text: "Subcategory: " +
                            _data["subcategory"]["subcategory"],
                        align: TextAlign.center,
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
                    child: SubHeadingText(
                        text: "Availability Status: " + _data["availability"],
                        align: TextAlign.justify,
                        color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    child: SubHeadingText(
                        text: "Availabile Stock: ${_data["stock"]}",
                        align: TextAlign.justify,
                        color: Colors.black),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdateProduct(
                                      productid: widget.productid,
                                    )),
                          );
                        },
                        child: Text("Update")),
                  )
                ],
              ));
  }
}
