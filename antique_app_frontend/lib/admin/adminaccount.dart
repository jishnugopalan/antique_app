import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AdminAccount extends StatefulWidget {
  const AdminAccount({super.key});

  @override
  State<AdminAccount> createState() => _AdminAccountState();
}

class _AdminAccountState extends State<AdminAccount> {
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