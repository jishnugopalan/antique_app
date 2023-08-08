import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        crossAxisCount: 2,
        children: <Widget>[
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.redAccent[100],
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: Text(
                "Add Category",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () => {Navigator.pushNamed(context, '/addcategory')},
          ),
          GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.redAccent[100]),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8),
              child: Text(
                "Add Subcategory",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            onTap: () => {Navigator.pushNamed(context, '/addsubcategory')},
          ),
        ],
      ),
    );
  }
}
