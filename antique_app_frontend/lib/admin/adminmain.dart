import 'package:antique_app/admin/admin_dashboard.dart';
import 'package:antique_app/admin/adminaccount.dart';
import 'package:antique_app/admin/complaints.dart';
import 'package:antique_app/admin/shopapproval.dart';
import 'package:antique_app/admin/widgets/bottom_navigation.dart';
import 'package:flutter/material.dart';

final pages = [AdminDashboard(), ShopApproval(), AdminAccount(), ComplaintsPage()];
final tites = ["Home", "Shops", "Account", "Complaints"];

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: indexChanged,
      builder: (context, int index, child) {
        return Scaffold(
          appBar: AppBar(title: Text(tites[index])),
          bottomNavigationBar: const AdminBottomNav(),
          body: pages[index],          
        );
      },
    );
  }
}