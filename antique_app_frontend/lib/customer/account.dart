import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerAccount extends StatefulWidget {
  const CustomerAccount({super.key});

  @override
  State<CustomerAccount> createState() => _CustomerAccountState();
}

class _CustomerAccountState extends State<CustomerAccount> {
  final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: [
      ListTile(
            leading: const Icon(Icons.logout,),
            title: const Text("Logout"),
            onTap: () async {

              await storage.delete(key: "token");
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

            },


            selectedColor: Colors.green[800],

          ),
      ]),
    );
  }
}
