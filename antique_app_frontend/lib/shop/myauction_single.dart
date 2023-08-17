import 'dart:convert';

import 'package:antique_app/services/shopservice.dart';
import 'package:antique_app/widgets/textbox_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyAuctionSingle extends StatefulWidget {
  const MyAuctionSingle({super.key, required this.auctionid});
  final String auctionid;

  @override
  State<MyAuctionSingle> createState() => _MyAuctionSingleState();
}

class _MyAuctionSingleState extends State<MyAuctionSingle> {
  TextEditingController _price = TextEditingController();
  ShopService _shopService = ShopService();
  String initial = "1000";
  String current = "2000";
  String status = "Active";
  bool isloading = false;
  dynamic _data;
  getAuctionDetailes() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }

    try {
      final Response res = await _shopService.getAuctionById(widget.auctionid);
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

  updateStatus() async {
    try {
      final Response res = await _shopService.updateAuctionStatus(
          widget.auctionid, "Unavailable");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Status updated successfully"),
        duration: Duration(milliseconds: 3000),
      ));
      setState(() {
        _data["availability"] = "Unavailable";
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
    getAuctionDetailes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auction"),
      ),
      body: ListView(padding: EdgeInsets.all(10), children: [
        Card(
          child: isloading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    Text(
                      _data["productname"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image.memory(
                      base64Decode(_data['image'].split(',')[1]),
                      fit: BoxFit.contain,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return Icon(Icons.image);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      _data['description'],
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 15),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     "Initial Amount : ₹ " + _data['price'].toString(),
                    //     style: TextStyle(
                    //         fontSize: 18, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     "Current Amount : ₹ $current",
                    //     style: TextStyle(
                    //         fontSize: 18, fontWeight: FontWeight.w500),
                    //   ),
                    // ),
                    // Container(
                    //   alignment: Alignment.topLeft,
                    //   child: Text(
                    //     "Updated By :\n Jishnu \n 7994245510",
                    //     style: TextStyle(
                    //         fontSize: 15, fontWeight: FontWeight.w500),
                    //     textAlign: TextAlign.left,
                    //   ),
                    // ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Status : " + _data["availability"],
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: TextButton(
                            onPressed: () {
                              updateStatus();
                            },
                            child: Text("Click to Deactivate")))
                  ],
                ),
        )
      ]),
    );
  }
}
