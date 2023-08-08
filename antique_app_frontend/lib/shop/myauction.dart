import 'package:flutter/material.dart';

import 'myauction_single.dart';

class MyAuction extends StatefulWidget {
  const MyAuction({super.key});

  @override
  State<MyAuction> createState() => _MyAuctionState();
}

class _MyAuctionState extends State<MyAuction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Auction"),
      ),
      body: ListView(
        padding: EdgeInsets.all(10),
        children: [
          ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const MyAuctionSingle()),
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
      ),
    );
  }
}
