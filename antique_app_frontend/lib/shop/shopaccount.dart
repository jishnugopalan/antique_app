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
          leading: const Icon(Icons.email),
          title: const Text("Add Complaint"),
          splashColor: Colors.grey,
          onTap: () async {
            Navigator.pushNamed(context, "/add_complaint");
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text("My Complaint"),
          splashColor: Colors.grey,
          onTap: () async {
            Navigator.pushNamed(context, "/view_my_complaint");
          },
        ),
        ListTile(
          leading: const Icon(Icons.account_circle),
          title: const Text("My Profile"),
          splashColor: Colors.grey,
          onTap: () async {
            Navigator.pushNamed(context, "/profile");
          },
        ),
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
