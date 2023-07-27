import 'dart:convert';

import 'package:antique_app/services/productservice.dart';
import 'package:antique_app/services/shopservice.dart';
import 'package:antique_app/shop/viewmyproduct.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShopProducts extends StatefulWidget {
  const ShopProducts({super.key});

  @override
  State<ShopProducts> createState() => _ShopProductsState();
}

class _ShopProductsState extends State<ShopProducts> {
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  ShopService service1 = ShopService();
  ProductService service2 = ProductService();
  List<dynamic> _data = [];

  Future<void> getAllProducts() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    String shopid = "";
    try {
      final Response? response3 = await service1.getShopByUserId(userid!);
      shopid = response3!.data["_id"];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
    try {
      final Response res = await service2.getProductsByShopId(shopid);
      print(res);
      setState(() {
        _data = res.data;
        isLoading = false;
      });
    } on DioException catch (e) {
      print(e.response!.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Products"),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewShopProduct(
                                    productid: _data[index]["_id"],
                                  )),
                        );
                      },
                      splashColor: Colors.deepPurple,
                      tileColor: Colors.grey[200],
                      leading: Image.memory(
                        base64Decode(_data[index]["image"].split(',')[1]),
                        fit: BoxFit.contain,
                        errorBuilder: (BuildContext context, Object exception,
                            StackTrace? stackTrace) {
                          return Icon(Icons.image);
                        },
                      ),
                      title: SubHeadingText(
                          text: _data[index]["productname"],
                          align: TextAlign.left,
                          color: Colors.black),
                      subtitle: Text(_data[index]["category"]["category"] +
                          "," +
                          _data[index]["subcategory"]["subcategory"]),
                    ),
                  );
                },
              ));
  }
}
