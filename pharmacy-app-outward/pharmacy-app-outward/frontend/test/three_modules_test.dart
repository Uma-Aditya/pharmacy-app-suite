import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/modules/catalogue_search_units/module.dart';
import 'package:pharmacy_app/modules/catalogue_search_units/screens/medicine_list_screen.dart';
import 'package:pharmacy_app/modules/outward_sales_report_scanning/module.dart';
import 'package:pharmacy_app/modules/outward_sales_report_scanning/screens/sales_hub_screen.dart';
import 'package:pharmacy_app/modules/suppliers_purchase_orders/module.dart';
import 'package:pharmacy_app/modules/suppliers_purchase_orders/screens/supplier_list_screen.dart';
import 'package:pharmacy_app/modules/suppliers_purchase_orders/screens/po_list_screen.dart';

void main() {
  testWidgets('Module 2: CatalogueModuleScreen mounts and shows MedicineListScreen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CatalogueModuleScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MedicineListScreen), findsOneWidget);
  });

  testWidgets('Module 7: OutwardSalesReportScanningScreen mounts and shows SalesHubScreen', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OutwardSalesReportScanningScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SalesHubScreen), findsOneWidget);
  });

  testWidgets('Module 3: SuppliersPurchaseOrdersScreen mounts with Suppliers and PO tabs', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SuppliersPurchaseOrdersScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(SuppliersPurchaseOrdersScreen), findsOneWidget);
    expect(find.byType(SupplierListScreen), findsOneWidget);
    expect(find.text('Suppliers'), findsWidgets);
    expect(find.text('Purchase Orders'), findsOneWidget);

    // Switch to Purchase Orders tab
    await tester.tap(find.text('Purchase Orders'));
    await tester.pumpAndSettle();

    expect(find.byType(POListScreen), findsOneWidget);
  });
}
