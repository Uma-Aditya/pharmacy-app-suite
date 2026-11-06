import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pharmacy_app/modules/suppliers_purchase_orders/module.dart';
import 'package:pharmacy_app/modules/suppliers_purchase_orders/screens/supplier_list_screen.dart';

void main() {
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
  });
}
