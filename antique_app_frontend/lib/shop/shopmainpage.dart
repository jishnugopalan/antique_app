import 'package:antique_app/shop/addproduct.dart';
import 'package:antique_app/shop/orders.dart';
import 'package:antique_app/shop/shopaccount.dart';
import 'package:antique_app/shop/shopdashboard.dart';
import 'package:antique_app/shop/widgets/shop_drawer_nav.dart';
import 'package:antique_app/shop/widgets/shopbottomnav.dart';
import 'package:flutter/material.dart';

final pages = [ShopDashboard(), ShopAccount(), ShopOrders()];
final tites = ["Home", "Account", "Orders"];

class ShopMainPage extends StatelessWidget {
  const ShopMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChanged,
      builder: (context, int index, child) {
        return Scaffold(
          appBar: AppBar(title: Text(tites[index])),
          bottomNavigationBar: const ShopBottomNav(),
          body: pages[index],
          drawer: ShopDrawer(),
        );
      },
    );
  }
}
