import 'dart:convert';

import 'package:antique_app/customer/viewsingleproduct.dart';
import 'package:antique_app/services/orderservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ViewOrderSingle extends StatefulWidget {
  const ViewOrderSingle({super.key, required this.orderid});
  final String orderid;

  @override
  State<ViewOrderSingle> createState() => _ViewOrderSingleState();
}

class _ViewOrderSingleState extends State<ViewOrderSingle> {
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
                    "Order ID" + _data["_id"],
                    style: TextStyle(fontSize: 15),
                  ),
                  Text("Total: " + _data["total"].toString(),
                      style: TextStyle(fontSize: 15)),
                  Text("Order Status: " + _data["orderstatus"].toString(),
                      style: TextStyle(fontSize: 15)),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Shipping Address",
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(_data["shippingid"]["fullname"]),
                  Text(_data["shippingid"]["housename"]),
                  Text(_data["shippingid"]["district"]),
                  Text(_data["shippingid"]["city"]),
                  Text("Pincode: " + _data["shippingid"]["phone"].toString()),
                  Text("Phone: " + _data["shippingid"]["pincode"].toString()),
                  SizedBox(
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ViewSingleProduct(
                                            productid: products[index]
                                                ["product"]["_id"],
                                          )),
                                );
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
                      })
                ],
              ));
  }
}
