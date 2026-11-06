import 'package:flutter/material.dart';
import 'package:pharmacy_app/modules/shared/theme/colors.dart';
import 'screens/supplier_list_screen.dart';
import 'screens/po_list_screen.dart';

/// Module 3 entrypoint: Suppliers & Purchase Orders
class SuppliersPurchaseOrdersScreen extends StatelessWidget {
  final int initialTabIndex;

  const SuppliersPurchaseOrdersScreen({super.key, this.initialTabIndex = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: initialTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Suppliers & Purchase Orders'),
          backgroundColor: AppColors.matcha,
          foregroundColor: Colors.white,
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: 'Suppliers'),
              Tab(icon: Icon(Icons.receipt_long_outlined), text: 'Purchase Orders'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            SupplierListScreen(),
            POListScreen(),
          ],
        ),
      ),
    );
  }
}
