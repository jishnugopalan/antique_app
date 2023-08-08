import 'dart:convert';

import 'package:antique_app/customer/viewordersingle.dart';
import 'package:antique_app/services/orderservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyOrdersCustomer extends StatefulWidget {
  const MyOrdersCustomer({super.key});

  @override
  State<MyOrdersCustomer> createState() => _MyOrdersCustomerState();
}

class _MyOrdersCustomerState extends State<MyOrdersCustomer> {
  OrderService _orderService = OrderService();
  final storage = const FlutterSecureStorage();
  bool isloading = false;
  List<dynamic> _data = [];
  getAllOrders() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final Response res = await _orderService.getOrderByCustomerID(userid!);
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
        appBar: AppBar(title: Text("My Orders")),
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
                                  builder: (context) => ViewOrderSingle(
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
