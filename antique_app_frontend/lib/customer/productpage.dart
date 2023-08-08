import 'dart:convert';

import 'package:antique_app/customer/viewsingleproduct.dart';
import 'package:antique_app/services/productservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key, required this.subcategoryid});
  final String subcategoryid;

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  ProductService _productService = ProductService();
  bool isLoading = false;
  List<dynamic> _data = [];
  Future<void> getProducts() async {
    setState(() {
      isLoading = true;
    });
    try {
      final Response res =
          await _productService.getProductBySubCategory(widget.subcategoryid);
      print(res);
      setState(() {
        _data = res.data;
        isLoading = false;
      });
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void dispose() {
    // your dispose part

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    getProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Product"),
          actions: [
            Container(
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, "/cart");
                },
              ),
            )
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, mainAxisSpacing: 10),
                      padding: EdgeInsets.all(10),
                      itemCount: _data.length,
                      itemBuilder: (BuildContext context, int index) {
                        var price = _data[index]["price"] -
                            (_data[index]["price"] *
                                (_data[index]["discount_percentage"] / 100.0));
                        return GestureDetector(
                          child: Container(
                            margin: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              color: Colors.greenAccent[100],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // SizedBox(height: 8.0),
                                Container(
                                  height: 100,
                                  width: 100,
                                  child: Image.memory(
                                    base64Decode(
                                        _data[index]['image'].split(',')[1]),
                                    // base64Decode(_data[index]["image"]
                                    //     .image
                                    //     .split(',')[1]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Text(
                                  _data[index]["productname"],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0,
                                  ),
                                ),
                                Text("₹" + price.toString())
                              ],
                            ),
                          ),
                          onTap: () {
                            print(_data[index]["_id"]);

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewSingleProduct(
                                        productid: _data[index]["_id"],
                                      )),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ));
  }
}
