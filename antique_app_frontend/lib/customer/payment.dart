import 'dart:convert';

import 'package:antique_app/customer/paymentsuccess.dart';
import 'package:antique_app/services/productservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.orderid, required this.amount});
  final String orderid;
  final String amount;

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  ProductService _productService = ProductService();
  String cardNumber = '';
  String expiryDate = '';
  String cvv = '';
  var products = [];

  Future<void> getProductsOrderById() async {
    try {
      final Response res = await _productService.getOrderById(widget.orderid);
      print(res.data);
      var p = res.data["products"];
      for (int i = 0; i < p.length; i++) {
        print(p[i]["product"]["_id"]);
        print(p[i]["quantity"]);
        products.add(
            {"productid": p[i]["product"]["_id"], "qty": p[i]["quantity"]});
      }
      print(products);
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  final storage = const FlutterSecureStorage();
  Future<void> _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      // Process payment logic here
      print('Payment submitted!');
      print('Card Number: $cardNumber');
      print('Expiry Date: $expiryDate');
      print('CVV: $cvv');
      Map<String, String> allValues = await storage.readAll();
      String? userid = allValues["userid"];
      var paymentdata = jsonEncode({
        "user": userid,
        "order": widget.orderid,
        "amount": widget.amount,
        "status": "completed"
      });

      try {
        final Response res = await _productService.startPayment(paymentdata);
        print(res.data);
        print("Payment completed");
        try {
          final Response res =
              await _productService.deleteAllCartItems(userid!);
          print(res.data);
          print("Cart Items Deleted");
          try {
            for (int i = 0; i < products.length; i++) {
              print(products[i]);
              final Response res = await _productService.decreaseStock(
                  products[i]["productid"], products[i]["qty"]);
              print("Stock decreased " + i.toString());
            }
            try {
              final Response res = await _productService.updateOrderStatus(
                  widget.orderid, "Order Confirmed");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PaymentSuccessPage()),
              );
            } on DioException catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Error occurred,update order status"),
                duration: Duration(milliseconds: 300),
              ));
            }
          } on DioException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Error occurred stock"),
              duration: Duration(milliseconds: 1000),
            ));
          }
        } on DioException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Error occurred,please try again"),
            duration: Duration(milliseconds: 300),
          ));
        }
      } on DioException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again"),
          duration: Duration(milliseconds: 1000),
        ));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getProductsOrderById();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(10),
            children: [
              Text(
                "Amount: ₹ ${widget.amount}",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Card Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your card number';
                  }
                  return null;
                },
                onChanged: (value) {
                  cardNumber = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the expiry date';
                  }
                  return null;
                },
                onChanged: (value) {
                  expiryDate = value;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'CVV'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your CVV';
                  }
                  return null;
                },
                onChanged: (value) {
                  cvv = value;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPayment,
                child: Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
