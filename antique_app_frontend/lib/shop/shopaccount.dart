import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShopAccount extends StatefulWidget {
  const ShopAccount({super.key});

  @override
  State<ShopAccount> createState() => _ShopAccountState();
}

class _ShopAccountState extends State<ShopAccount> {
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          splashColor: Colors.grey,
          onTap: () async {
            await storage.delete(key: "token");
            Navigator.of(context).pushNamedAndRemoveUntil(
                '/login', (Route<dynamic> route) => false);
          },
        ),
      ]),
    );
  }
}
