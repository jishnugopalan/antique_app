import 'package:antique_app/customer/auction_single.dart';
import 'package:antique_app/customer/widgets/bottom_navigation.dart';
import 'package:antique_app/customer/widgets/drawer_nav.dart';
import 'package:flutter/material.dart';

class Auction extends StatefulWidget {
  const Auction({super.key});

  @override
  State<Auction> createState() => _AuctionState();
}

class _AuctionState extends State<Auction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.all(10),
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AuctionSingle()),
            );
          },
          leading: Image.asset(
            "assets/antiqueimg.jpg",
          ),
          title: const Text(
            "Gramophone",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          subtitle: const Text(
            "Active",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    ));
  }
}
