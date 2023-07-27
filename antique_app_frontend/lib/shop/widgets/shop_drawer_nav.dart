import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShopDrawer extends StatelessWidget {
  ShopDrawer({super.key});
final storage = FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: [
          UserAccountsDrawerHeader(
            accountName: const Text("Ashish Rawat"),
            accountEmail: const Text("ashishrawat2911@gmail.com"),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: const Text(
                "A",
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            splashColor: Colors.grey,
            onTap: () {
              print("fff");
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text("My Products"),
            splashColor: Colors.grey,
             onTap: () async {

             
            },
          ),
          const Divider(
            color: Colors.black,
          ),
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text("Help"),
            splashColor: Colors.grey,
            onTap: () {
              print("fff");
            },
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text("Contact"),
            splashColor: Colors.grey,
            onTap: () {
              print("fff");
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            splashColor: Colors.grey,
             onTap: () async {

              await storage.delete(key: "token");
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);

            },
          ),
        ]),
      ),
    );
  }
}