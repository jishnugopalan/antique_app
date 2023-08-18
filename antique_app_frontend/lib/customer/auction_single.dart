import 'dart:convert';

import 'package:antique_app/services/shopservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:antique_app/widgets/textbox_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuctionSingle extends StatefulWidget {
  const AuctionSingle({super.key, required this.auctionid});
  final String auctionid;

  @override
  State<AuctionSingle> createState() => _AuctionSingleState();
}

class _AuctionSingleState extends State<AuctionSingle> {
  TextEditingController _price = TextEditingController();
  ShopService _shopService = ShopService();
  final storage = const FlutterSecureStorage();

  String initial = "1000";
  String current = "2000";
  String status = "Active";
  bool isloading = false;
  dynamic _data;
  List<dynamic> _bid = [];
  List amount = [];
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
          _bid = res.data["bids"];
          isloading = false;
        });
      }
      for (int i = 0; i < _bid.length; i++) {
        amount.add(_bid[i]["bidAmount"]);
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

  addAmount() async {
    if (_price.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Please add amouunt"),
              content: Text("Please add an amount"),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    } else {
      Map<String, String> allValues = await storage.readAll();
      String? userid = allValues["userid"];
      var detailes = jsonEncode({
        "auctionid": widget.auctionid,
        "bidder": userid,
        "bidAmount": _price.text
      });
      try {
        final Response res = await _shopService.updateBid(detailes);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Bid Amount Added"),
          duration: Duration(milliseconds: 3000),
        ));
        getAuctionDetailes();
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
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        "Initial Price :" + _data['price'].toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(10),
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Bidders",
                          style: TextStyle(fontSize: 18),
                        )),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _bid.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(_bid[index]["bidder"]["name"]),
                          subtitle:
                              Text("₹" + _bid[index]["bidAmount"].toString()),
                        );
                      },
                    ),

                    Container(
                      alignment: Alignment.topLeft,
                      child: Text(
                        _data['description'],
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    if (_data["availability"] == "Active") ...[
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration:
                            InputDecoration(label: Text("Enter an amount")),
                        controller: _price,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            addAmount();
                          },
                          child: Text("Add Amount")),
                    ],

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
                      child: SubHeadingText(
                          text: "Shop Details",
                          align: TextAlign.left,
                          color: Colors.black),
                    ),
                    Container(
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Text(_data["shop"]["shopname"]),
                          Text(_data["shop"]["shopcity"]),
                          Text(_data["shop"]["shopdistrict"]),
                          Text(_data["shop"]["shopphone"].toString()),
                          Text(_data["shop"]["shopemail"]),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
        )
      ]),
    );
  }
}
