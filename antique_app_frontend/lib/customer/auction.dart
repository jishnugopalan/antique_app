import 'dart:convert';

import 'package:antique_app/customer/auction_single.dart';
import 'package:antique_app/customer/widgets/bottom_navigation.dart';
import 'package:antique_app/customer/widgets/drawer_nav.dart';
import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Auction extends StatefulWidget {
  const Auction({super.key});

  @override
  State<Auction> createState() => _AuctionState();
}

class _AuctionState extends State<Auction> {
  ShopService _shopService = ShopService();
  bool isloading = false;
  List<dynamic> _data = [];
  getAuctionData() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    try {
      final Response res = await _shopService.getAllAuction();
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
    getAuctionData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: _data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuctionSingle(
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
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _data[index]["availability"],
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ));
  }
}
