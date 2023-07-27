import 'package:antique_app/services/shopservice.dart';
import 'package:antique_app/widgets/text_widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShopDashboard extends StatefulWidget {
  const ShopDashboard({super.key});

  @override
  State<ShopDashboard> createState() => _ShopDashboardState();
}

class _ShopDashboardState extends State<ShopDashboard> {
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  ShopService service = ShopService();
  String isApproved = "Pleas wait...";
  Future<void> getShopApprovalStatus() async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> allValues = await storage.readAll();
    String? userid = allValues["userid"];
    try {
      final Response res = await service.getShopByUserId(userid!);
      print(res.data["admin_status"]);
      if (res.statusCode! >= 200) {
        setState(() {
          isLoading = false;
          isApproved = res.data["admin_status"];
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
    getShopApprovalStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(children: [
              if (isApproved == "Rejected") ...[
                SizedBox(
                  height: MediaQuery.of(context).size.height * .28,
                ),
                const Center(
                  child: SubHeadingText(
                      text: "Not Approved",
                      align: TextAlign.justify,
                      color: Colors.red),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const SubHeadingText(
                      text:
                          "Your application is not approved.Please wait for somedays or contact us",
                      align: TextAlign.justify,
                      color: Colors.black),
                )
              ] else ...[
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 20),
                  child: const HeadingText(
                      text: "Products",
                      align: TextAlign.left,
                      color: Colors.deepPurple),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/add_product');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .45,
                        height: MediaQuery.of(context).size.width * .4,
                        color: Colors.grey[200],
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        margin: const EdgeInsets.only(left: 10),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add,
                                color: Colors.red,
                                size: 30,
                              ),
                              SubHeadingText(
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  text: "Add Products")
                            ]),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/shop_products');
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * .45,
                        height: MediaQuery.of(context).size.width * .4,
                        color: Colors.grey[200],
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        margin: const EdgeInsets.only(left: 20),
                        child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.shopping_bag,
                                color: Colors.green,
                                size: 30,
                              ),
                              SubHeadingText(
                                  align: TextAlign.center,
                                  color: Colors.black,
                                  text: "My Products")
                            ]),
                      ),
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 20),
                  child: const HeadingText(
                      text: "Auction",
                      align: TextAlign.left,
                      color: Colors.deepPurple),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      height: MediaQuery.of(context).size.width * .4,
                      color: Colors.grey[200],
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      margin: const EdgeInsets.only(left: 10),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.post_add,
                              color: Colors.blue,
                              size: 30,
                            ),
                            SubHeadingText(
                                align: TextAlign.justify,
                                color: Colors.black,
                                text: "Add Auction")
                          ]),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * .45,
                      height: MediaQuery.of(context).size.width * .4,
                      color: Colors.grey[200],
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      margin: const EdgeInsets.only(left: 20),
                      child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.view_headline_outlined,
                              color: Colors.green,
                              size: 30,
                            ),
                            SubHeadingText(
                                align: TextAlign.center,
                                color: Colors.black,
                                text: "History")
                          ]),
                    )
                  ],
                )
              ],
            ]),
    );
  }
}
