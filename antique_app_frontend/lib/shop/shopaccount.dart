import 'package:flutter/material.dart';

class ShopAccount extends StatefulWidget {
  const ShopAccount({super.key});

  @override
  State<ShopAccount> createState() => _ShopAccountState();
}

class _ShopAccountState extends State<ShopAccount> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("account"),);
  }
}