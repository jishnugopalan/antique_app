import 'package:antique_app/customer/account.dart';
import 'package:antique_app/customer/cart.dart';
import 'package:antique_app/customer/categories.dart';
import 'package:antique_app/customer/dashboard.dart';
import 'package:antique_app/customer/widgets/bottom_navigation.dart';
import 'package:antique_app/customer/widgets/drawer_nav.dart';
import 'package:flutter/material.dart';

final pages = [CustomerHome(), Categories(), CustomerAccount(), Cart()];
final tites = ["Home", "Categories", "Account", "Cart"];

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChanged,
      builder: (context, int index, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text(tites[index]),
            actions: [
              Container(
                child: IconButton(
                  icon: Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(context, "/cart");
                  },
                ),
              )
            ],
          ),
          bottomNavigationBar: const CustomerBottomNav(),
          body: pages[index],
          drawer: const CustomerDrawer(),
        );
      },
    );
  }
}
