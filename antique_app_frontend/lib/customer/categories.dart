import 'package:antique_app/customer/widgets/bottom_navigation.dart';
import 'package:antique_app/customer/widgets/drawer_nav.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text("Category"),
    );
  }
}
