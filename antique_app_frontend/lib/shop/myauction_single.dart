import 'package:antique_app/widgets/textbox_widget.dart';
import 'package:flutter/material.dart';

class MyAuctionSingle extends StatefulWidget {
  const MyAuctionSingle({super.key});

  @override
  State<MyAuctionSingle> createState() => _MyAuctionSingleState();
}

class _MyAuctionSingleState extends State<MyAuctionSingle> {
  TextEditingController _price = TextEditingController();
  String initial = "1000";
  String current = "2000";
  String status = "Active";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auction"),
      ),
      body: ListView(padding: EdgeInsets.all(10), children: [
        Card(
          child: Column(
            children: [
              Text(
                "Gramophone",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10,
              ),
              Image.asset(
                "assets/antiqueimg.jpg",
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Gold Brass Woooden Flower Carving Vintage Gramophone,",
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Initial Amount : ₹ $initial",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Current Amount : ₹ $current",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Updated By :\n Jishnu \n 7994245510",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text(
                  "Status : $status",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      onPressed: () {
                        setState(() {
                          status = "Inactive";
                        });
                      },
                      child: Text("Click to Deactivate")))
            ],
          ),
        )
      ]),
    );
  }
}
