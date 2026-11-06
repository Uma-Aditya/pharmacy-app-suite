import 'package:flutter/material.dart';
import '../../core/widgets/module_placeholder.dart';

class OutwardSalesReportScanningScreen extends StatelessWidget {
  const OutwardSalesReportScanningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ModulePlaceholderScreen(
      moduleNumber: 7,
      title: 'Outward Sales Report Scanning',
      scope: 'Sales report photo capture, OCR extraction, and stock deduction confirmation.',
      member: 'Member 7',
      integrationWithInventory: 'Confirmed sales deduct stock from earliest-expiring batches (FEFO).',
    );
  }
}
