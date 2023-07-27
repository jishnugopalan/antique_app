import 'dart:convert';

import 'package:antique_app/services/authservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;
  final storage = FlutterSecureStorage();
  AuthService service = AuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    checkAuthentication();
    super.initState();
  }

  String? validateEmail(String? value) {
    String pattern = r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Email is required';
    } else if (!regExp.hasMatch(value)) {
      return 'Invalid email';
    } else {
      return null;
    }
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return 'Password is required';
    } else if (value.length < 8) {
      return 'Password must be more than 8 characters';
    } else {
      return null;
    }
  }

  showError(String content, String title) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  Future<void> submitForm() async {
    var user = jsonEncode(
        {"email": _emailController.text, "password": _passwordController.text});

    try {
      final Response? response = await service.loginUser(user);
      print(response!.data);
      Map<String, String> allValues = await storage.readAll();
      String normalizedSource =
          base64Url.normalize(allValues["token"]!.split(".")[1]);
      String userid =
          json.decode(utf8.decode(base64Url.decode(normalizedSource)))["_id"];
      print(userid);
      await storage.write(key: "userid", value: userid);
      // Map<String, dynamic> s=jsonDecode(response.data);
      if (response.data["user"]["usertype"] == "customer") {
        Navigator.pushNamedAndRemoveUntil(
            context, '/customer_dashboard', (route) => false);
        dev.log("customer");
      } else if (response.data["user"]["usertype"] == "shop") {
        Navigator.pushNamedAndRemoveUntil(
            context, '/shop_dashboard', (route) => false);
        dev.log("shop");
      } else if (response.data["user"]["usertype"] == "admin") {
        dev.log("admin");
        Navigator.pushNamedAndRemoveUntil(
            context, '/admin_dashboard', (route) => false);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);

        showError(e.response!.data["msg"], "Login Failed");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater", "Oops");
      }
    }
  }

  Future<void> checkAuthentication() async {
    dev.log("in check auth");
    try {
      Map<String, String> allValues = await storage.readAll();
      if (allValues["token"]!.isEmpty) {
        Navigator.of(context).pushNamedAndRemoveUntil(
            '/registration', (Route<dynamic> route) => false);
      } else {
        dev.log("token is here");
        Map<String, String> allValues = await storage.readAll();
        String normalizedSource =
            base64Url.normalize(allValues["token"]!.split(".")[1]);
        String userid =
            json.decode(utf8.decode(base64Url.decode(normalizedSource)))["_id"];
        this.getUser(userid);
      }
    } catch (e) {
      dev.log(e.toString());
    }
  }

  Future<void> getUser(String userid) async {
    try {
      final Response? response = await service.getUser(userid);
      if (response?.data["usertype"] == "customer") {
        dev.log("customer");
        Navigator.pushNamedAndRemoveUntil(
            context, '/customer_dashboard', (route) => false);
      } else if (response?.data["usertype"] == "shop") {
        dev.log("shop");
        Navigator.pushNamedAndRemoveUntil(
            context, '/shop_dashboard', (route) => false);
      } else if (response?.data["usertype"] == "admin") {
        dev.log("admin");
        Navigator.pushNamedAndRemoveUntil(
            context, '/admin_dashboard', (route) => false);
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print(e.response!.data);

        showError("Login failed", "Please login again");
      } else {
        // Something happened in setting up or sending the request that triggered an Error
        showError("Error occured,please try againlater", "Oops");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const HeadingText(
                    text: "Login",
                    align: TextAlign.left,
                    color: Colors.deepPurple),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_hidePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _hidePassword = !_hidePassword;
                        });
                      },
                    ),
                  ),
                  validator: validatePassword,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/forgotpassword');
                      },
                      child: const DescriptionText(
                        align: TextAlign.left,
                        color: Colors.deepPurple,
                        text: 'Forgot Password',
                      )),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10.0),
                        shape: const LinearBorder(),
                        backgroundColor: Colors.deepPurple),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        dev.log(
                            "Email: ${_emailController.text}, Password: ${_passwordController.text}");
                        submitForm();
                        // Implement login functionality here
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registration');
                    },
                    child: const DescriptionText(
                      align: TextAlign.left,
                      color: Colors.deepPurple,
                      text: "Don't have any account,register now",
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
