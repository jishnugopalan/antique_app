import 'package:antique_app/customer/productpage.dart';
import 'package:antique_app/customer/widgets/drawer_nav.dart';
import 'package:antique_app/services/shopservice.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class SubcategoryPage extends StatefulWidget {
  const SubcategoryPage({super.key, required this.categoryid});
  final String categoryid;

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  late final Response? response2;
  ShopService service = ShopService();
  List<String> items = [];
  getSubCategory() async {
    try {
      response2 = await service.getSubCategory(widget.categoryid);
      print(response2!.data);
      final jsonData2 = response2!.data;
      // subcategory.clear();
      for (int i = 0; i < jsonData2.length; i++) {
        setState(() {
          items.add(jsonData2[i]["subcategory"]);
        });
      }
    } on DioException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Error occurred,please try again"),
        duration: Duration(milliseconds: 300),
      ));
    }
  }

  gotoProducts(index) {
    final jsonData = response2!.data;
    print(jsonData[index]["_id"]);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ProductPage(subcategoryid: jsonData[index]["_id"]),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSubCategory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Subcategories'),
        ),
        // drawer: CustomerDrawer(),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: items.length,
              padding: const EdgeInsets.all(10),
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
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    gotoProducts(index);
                  },
                );
              },
            ),
          ),
        ]));
  }
}
