import 'package:antique_app/customer/subcategory.dart';
import 'package:antique_app/customer/widgets/bottom_navigation.dart';
import 'package:antique_app/customer/widgets/drawer_nav.dart';
import 'package:antique_app/services/shopservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class CustomerHome extends StatefulWidget {
  const CustomerHome({super.key});

  @override
  State<CustomerHome> createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  ShopService _service = ShopService();
  List<String> items = [];
  bool isLoading = false;
  late final Response? res;
  Future<void> getAllCategory() async {
    setState(() {
      isLoading = true;
    });
    try {
      res = await _service.getAllCategory();
      print(res);
      setState(() {
        isLoading = false;
      });
      final jsonData = res!.data;
      for (int i = 0; i < jsonData.length; i++) {
        setState(() {
          items.add(jsonData[i]["category"]);
        });
      }
    } on DioException catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  gotoSubCategory(index) {
    final jsonData = res!.data;
    print(jsonData[index]["_id"]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            SubcategoryPage(categoryid: jsonData[index]["_id"]),
      ),
    );
    print(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    getAllCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            child: const HeadingText(
                text: "TechRelics", align: TextAlign.left, color: Colors.black),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  child: Container(
                    margin: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.greenAccent[100],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 8.0),
                        Text(
                          items[index],
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    print(index);
                    gotoSubCategory(index);
                    // Navigator.pushNamed(context, '/subcategory');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
