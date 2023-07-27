import 'package:antique_app/admin/adminmain.dart';
import 'package:antique_app/admin/successmsg.dart';
import 'package:antique_app/customer/account.dart';
import 'package:antique_app/customer/cart.dart';
import 'package:antique_app/customer/categories.dart';
import 'package:antique_app/customer/dashboard.dart';
import 'package:antique_app/customer/mainpage.dart';
import 'package:antique_app/customer_reg.dart';
import 'package:antique_app/forgotpassword.dart';
import 'package:antique_app/login.dart';
import 'package:antique_app/registration.dart';
import 'package:antique_app/shop/addproduct.dart';
import 'package:antique_app/shop/myproducts.dart';
import 'package:antique_app/shop/shopmainpage.dart';
import 'package:antique_app/shop_reg.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Antique App",
      theme: ThemeData(
          primaryColor: Colors.blue,
          primarySwatch: Colors.deepPurple,
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            shape: const StadiumBorder(),
          ))),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/registration': (context) => const RegistrationPage(),
        '/customer_registration': (context) => const CustomerRegistration(),
        '/shop_registration': (context) => const ShopRegistration(),
        '/forgotpassword': (context) => const ForgotpasswordPage(),
        '/customer_dashboard': (context) => const MainPage(),
        '/customer_account': (context) => const CustomerAccount(),
        '/cart': (context) => const Cart(),
        '/category': (context) => const Categories(),
        '/admin_dashboard': (context) => const AdminMain(),
        '/adminapprove_msg': (context) => const ShopApproveSuccess(
              message: '',
            ),
        '/shop_dashboard': (context) => const ShopMainPage(),
        '/add_product': (context) => const AddProduct(),
        '/shop_products': (context) => const ShopProducts()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _textEditingController = TextEditingController();
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home"),
        ),
        body: const RegistrationPage());
  }
}