import 'package:antique_app/services/authservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = const FlutterSecureStorage();
  bool isloading = false;
  dynamic _data;
  AuthService _authService = AuthService();

  getProfile() async {
    if (mounted) {
      setState(() {
        isloading = true;
      });
    }
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res = await _authService.getUser(userid!);
      if (mounted) {
        setState(() {
          _data = res.data;
          isloading = false;
        });
      }
    } on DioException catch (e) {
      setState(() {
        isloading = false;
      });
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
    return Scaffold(
        appBar: AppBar(title: Text("My Profile")),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: EdgeInsets.all(20),
                children: [
                  Text(
                    _data["name"],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _data["email"],
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _data["phone"].toString(),
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ));
  }
}
