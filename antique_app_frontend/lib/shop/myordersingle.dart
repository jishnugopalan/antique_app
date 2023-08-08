import 'dart:convert';

import 'package:antique_app/customer/viewsingleproduct.dart';
import 'package:antique_app/services/orderservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyOrderSingle extends StatefulWidget {
  const MyOrderSingle({super.key, required this.orderid});
  final String orderid;

  @override
  State<MyOrderSingle> createState() => _MyOrderSingleState();
}

class _MyOrderSingleState extends State<MyOrderSingle> {
  OrderService _orderService = OrderService();
  bool isloading = false;
  dynamic _data;
  List<dynamic> products = [];
  getOrderDetails() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final Response res = await _orderService.getOrderById(widget.orderid);
      print(res.data);
      if (mounted) {
        setState(() {
          _data = res.data;
          products = res.data["products"];
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

  updateStatus(type) async {
    if (type == 1) {
      try {
        final Response res = await _orderService.updateorderstatus(
            widget.orderid, "Order Packed");
        print(res.data);
        setState(() {
          _data["orderstatus"] = "Order Packed";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Order Status Changed Successfully"),
          duration: Duration(milliseconds: 1000),
        ));
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    } else if (type == 2) {
      try {
        final Response res = await _orderService.updateorderstatus(
            widget.orderid, "Hand Over To Courier");
        setState(() {
          _data["orderstatus"] = "Hand Over To Courier";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Order Status Changed Successfully"),
          duration: Duration(milliseconds: 1000),
        ));
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    } else if (type == 3) {
      try {
        final Response res = await _orderService.updateorderstatus(
            widget.orderid, "Order Delivered");
        setState(() {
          _data["orderstatus"] = "Order Delivered";
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Order Status Changed Successfully"),
          duration: Duration(milliseconds: 1000),
        ));
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Order Details")),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text(
                    "Order ID: " + _data["_id"],
                    style: TextStyle(fontSize: 15),
                  ),
                  Text("Total: ${_data["total"]}",
                      style: TextStyle(fontSize: 15)),
                  Text("Order Status: ${_data["orderstatus"]}",
                      style: TextStyle(fontSize: 15)),
                  Text("Change Order Status To"),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            updateStatus(1);
                          },
                          child: Text("Order Packed")),
                      TextButton(
                          onPressed: () {
                            updateStatus(2);
                          },
                          child: Text("Hand Over To Courier")),
                    ],
                  ),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            updateStatus(3);
                          },
                          child: Text("Order Delivered")),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Shipping Address",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(_data["shippingid"]["fullname"]),
                  Text(_data["shippingid"]["housename"]),
                  Text(_data["shippingid"]["district"]),
                  Text(_data["shippingid"]["city"]),
                  Text("Pincode: ${_data["shippingid"]["phone"]}"),
                  Text("Phone: ${_data["shippingid"]["pincode"]}"),
                  const SizedBox(
                    height: 20,
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.topLeft,
                          child: Column(children: [
                            ListTile(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ViewSingleProduct(
                                //             productid: products[index]
                                //                 ["product"]["_id"],
                                //           )),
                                // );
                              },
                              leading: Image.memory(
                                base64Decode(products[index]["product"]["image"]
                                    .split(',')[1]),
                                fit: BoxFit.contain,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Icon(Icons.image);
                                },
                              ),
                              title: Text(
                                  products[index]["product"]["productname"]),
                              subtitle:
                                  Text(products[index]["quantity"].toString()),
                            ),
                          ]),
                        );
                      }),
                ],
              ));
  }
}
