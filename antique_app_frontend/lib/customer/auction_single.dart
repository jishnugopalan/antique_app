import 'package:antique_app/widgets/textbox_widget.dart';
import 'package:flutter/material.dart';

class AuctionSingle extends StatefulWidget {
  const AuctionSingle({super.key});

  @override
  State<AuctionSingle> createState() => _AuctionSingleState();
}

class _AuctionSingleState extends State<AuctionSingle> {
  TextEditingController _price = TextEditingController();
  String initial = "1000";
  String current = "2000";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auction"),
      ),
      body: ListView(children: [
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
              Text(
                "Initial Amount : ₹ $initial",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Current Amount : ₹ $current",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              CustomTextBox(
                controller: _price,
                labelText: "Enter amount",
                keyboardType: TextInputType.number,
                prefixIcon: Icons.currency_rupee,
                validator: (p0) {},
              ),
              ElevatedButton(
                  onPressed: () {
                    if (_price.text.isEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Please enter an amount"),
                              content: Text(""),
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
                      setState(() {
                        current = _price.text;
                      });
                    }
                  },
                  child: Text("Submit")),
              SizedBox(
                height: 20,
              )
            ],
          ),
        )
      ]),
    );
  }
}
