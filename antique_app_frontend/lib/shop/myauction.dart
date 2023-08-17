import 'dart:convert';

import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'myauction_single.dart';

class MyAuction extends StatefulWidget {
  const MyAuction({super.key});

  @override
  State<MyAuction> createState() => _MyAuctionState();
}

class _MyAuctionState extends State<MyAuction> {
  ShopService _shopService = ShopService();
  bool isloading = false;
  List<dynamic> _data = [];

  final storage = const FlutterSecureStorage();
  getAuction() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    String shopid = "";
    try {
      final Response? response3 = await _shopService.getShopByUserId(userid!);
      shopid = response3!.data["_id"];
    } on DioException catch (e) {
      if (e.response != null) {
        // print(e.response!.data);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again 1"),
          duration: Duration(milliseconds: 300),
        ));
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Error occurred,please try again 2"),
          duration: Duration(milliseconds: 300),
        ));
      }
    }
    print(shopid);
    try {
      final Response res = await _shopService.getAuctionByShopid(shopid);
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
      print(e.response!.data);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again 3"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getAuction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Auction"),
      ),
      body: isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyAuctionSingle(
                                auctionid: _data[index]["_id"],
                              )),
                    );
                  },
                  leading: Image.memory(
                    base64Decode(_data[index]['image'].split(',')[1]),
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return Icon(Icons.image);
                    },
                  ),
                  title: Text(
                    _data[index]["productname"],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  subtitle: Text(
                    _data[index]["availability"],
                    style: TextStyle(color: Colors.red),
                  ),
                );
              }),
    );
  }
}
