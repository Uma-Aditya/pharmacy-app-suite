import 'package:flutter/material.dart';
import '../../core/widgets/module_placeholder.dart';

class SuppliersPurchaseOrdersScreen extends StatelessWidget {
  const SuppliersPurchaseOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      moduleNumber: 3,
      title: 'Suppliers, Purchase Orders & Goods Receipt',
      scope: 'Supplier vendor records, purchase orders, and goods receipt verification.',
      member: 'Member 3',
      integrationWithInventory: 'Inward deliveries create batches with expiry dates and increase available stock.',
    );
  }
}
