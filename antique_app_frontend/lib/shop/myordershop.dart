import 'dart:convert';

import 'package:antique_app/customer/viewordersingle.dart';
import 'package:antique_app/services/orderservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/shopservice.dart';
import 'myordersingle.dart';

class MyOrdersShop extends StatefulWidget {
  const MyOrdersShop({super.key});

  @override
  State<MyOrdersShop> createState() => _MyOrdersShopState();
}

class _MyOrdersShopState extends State<MyOrdersShop> {
  OrderService _orderService = OrderService();
  final storage = const FlutterSecureStorage();
  bool isloading = false;
  List<dynamic> _data = [];
  ShopService service = ShopService();
  String? shopid;
  getAllOrders() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response? response3 = await service.getShopByUserId(userid!);
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
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      print(shopid);
      final Response res = await _orderService.getOrderByShopID(shopid!);
      print(res.data);
      if (mounted) {
        setState(() {
          _data = res.data;
          isloading = false;
        });
      }
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
    getAllOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: Text("My Orders")),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: _data.length,
                itemBuilder: (context, index) {
                  List<dynamic> d = _data[index]["products"];
                  return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: d.length,
                      itemBuilder: (c, i) {
                        return ListTile(
                          onTap: () {
                            print(_data[index]["_id"]);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyOrderSingle(
                                        orderid: _data[index]["_id"],
                                      )),
                            );
                          },
                          leading: Image.memory(
                            base64Decode(
                                d[i]["product"]["image"].split(',')[1]),
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return const Icon(Icons.image);
                            },
                          ),
                          title: Text(d[i]["product"]["productname"]),
                          subtitle: Text(d[i]["quantity"].toString()),
                        );
                      });
                }));
  }
}
