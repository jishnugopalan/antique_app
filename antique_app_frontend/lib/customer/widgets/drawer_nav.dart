import 'package:antique_app/services/authservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomerDrawer extends StatefulWidget {
  const CustomerDrawer({super.key});

  @override
  State<CustomerDrawer> createState() => _CustomerDrawerState();
}

class _CustomerDrawerState extends State<CustomerDrawer> {
  final storage = FlutterSecureStorage();
  AuthService _authService = AuthService();
  String name = " ";
  String email = "";

  getProfile() async {
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res = await _authService.getUser(userid!);
      if (mounted) {
        setState(() {
          name = res.data["name"];
          email = res.data["email"];
        });
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(children: [
          UserAccountsDrawerHeader(
            accountName: Text(name),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
                  ? Colors.blue
                  : Colors.white,
              child: Text(
                name[0],
                style: TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text("Home"),
            splashColor: Colors.grey,
            onTap: () {
              Navigator.pushNamed(context, "/customer_dashboard");
            },
          ),
          ListTile(
            leading: const Icon(Icons.notes_rounded),
            title: const Text("My Orders"),
            splashColor: Colors.grey,
            onTap: () {
              Navigator.pushNamed(context, "/myorders_customers");
            },
          ),
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
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
            },
          ),
        ]),
      ),
    );
  }
}
