import 'package:flutter/material.dart';

import 'package:pharmacy_app/modules/shared/api/api_client.dart';
import 'package:pharmacy_app/modules/shared/theme/colors.dart';
import 'package:pharmacy_app/modules/shared/services/mock_data_service.dart';
import 'package:pharmacy_app/modules/shared/localization/app_localizations.dart';
import 'package:pharmacy_app/modules/shared/ui/entity_card.dart';
import 'package:pharmacy_app/modules/shared/ui/status_chip.dart';
import 'package:pharmacy_app/modules/shared/ui/search_field.dart';
import 'package:pharmacy_app/modules/shared/ui/filter_chips_row.dart';
import 'package:pharmacy_app/modules/shared/ui/empty_state.dart';
import 'package:pharmacy_app/modules/shared/ui/confirm_sheet.dart';
import 'supplier_form_screen.dart';
import 'supplier_detail_screen.dart';

enum SupplierFilter { all, active, inactive }

/// S1: SUPPLIER LIST SCREEN (Purchasing > Suppliers) - Section 10.4.3
class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  String _searchQuery = '';
  SupplierFilter _currentFilter = SupplierFilter.all;

  @override
  void initState() {
    super.initState();
    MockDataService().syncSuppliersFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final service = MockDataService();

    return AnimatedBuilder(
      animation: service,
      builder: (context, _) {
        final suppliers = service.suppliers.where((s) {
          // Status filter
          if (_currentFilter == SupplierFilter.active && !s.isActive)
            return false;
          if (_currentFilter == SupplierFilter.inactive && s.isActive)
            return false;

          // Search query
          if (_searchQuery.isEmpty) return true;
          final q = _searchQuery.toLowerCase();
          return s.name.toLowerCase().contains(q) ||
              s.supplierCode.toLowerCase().contains(q) ||
              s.phone.contains(q) ||
              (s.contactPerson?.toLowerCase().contains(q) ?? false);
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.canvas,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchField(
                  hintText: strings.search,
                  onChanged: (q) => setState(() => _searchQuery = q),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: FilterChipsRow<SupplierFilter>(
                        items: SupplierFilter.values,
                        selectedItem: _currentFilter,
                        labelBuilder: (f) {
                          switch (f) {
                            case SupplierFilter.all:
                              return strings.all;
                            case SupplierFilter.active:
                              return strings.active;
                            case SupplierFilter.inactive:
                              return strings.inactive;
                          }
                        },
                        onSelected: (filter) =>
                            setState(() => _currentFilter = filter),
                      ),
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: const Size(0, 36),
                      ),
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(strings.addSupplier),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SupplierFormScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => MockDataService().syncSuppliersFromBackend(),
                    child: suppliers.isEmpty
                        ? ListView(
                            children: [
                              EmptyState(
                                icon: Icons.local_shipping_outlined,
                                title: strings.noSuppliersYet,
                                actionLabel: strings.addSupplier,
                                onAction: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => const SupplierFormScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          )
                        : ListView.separated(
                            itemCount: suppliers.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final supplier = suppliers[index];
                              return EntityCard(
                                title: supplier.name,
                                leadingText: supplier.name.isNotEmpty
                                    ? supplier.name.substring(0, 1).toUpperCase()
                                    : 'S',
                                subtitle1:
                                    '${supplier.supplierCode} • ${supplier.contactPerson ?? '-'}',
                                subtitle2:
                                    'Phone: ${supplier.phone} • Terms: ${supplier.paymentTerms ?? 'Net 30'}',
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    StatusChip(
                                      status: supplier.isActive
                                          ? StatusType.active
                                          : StatusType.inactive,
                                      customLabel: supplier.isActive
                                          ? strings.active
                                          : strings.inactive,
                                    ),
                                    PopupMenuButton<String>(
                                      icon: const Icon(
                                        Icons.more_vert_rounded,
                                        size: 18,
                                        color: AppColors.inkSoft,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onSelected: (action) async {
                                        if (action == 'edit') {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => SupplierFormScreen(
                                                supplierToEdit: supplier,
                                              ),
                                            ),
                                          );
                                        } else if (action == 'delete') {
                                           final confirmed = await ConfirmSheet.show(
                                             context,
                                             title: strings.deleteSupplier,
                                             message:
                                                 'Are you sure you want to delete \? This will permanently remove the supplier from your store.',
                                             isDestructive: true,
                                             confirmLabel: strings.delete,
                                             cancelLabel: strings.cancel,
                                           );
                                           if (confirmed == true) {
                                             service.deleteSupplier(
                                               supplier.id,
                                             );
                                             try {
                                               await ApiClient().deleteSupplierStrict(
                                                 supplierId: supplier.id,
                                               );
                                             } catch (_) {}
                                             if (context.mounted) {
                                               ScaffoldMessenger.of(context).showSnackBar(
                                                 SnackBar(content: Text('\ deleted successfully')),
                                               );
                                             }
                                           }
                                         }
                                       },
                                       itemBuilder: (_) => [
                                       PopupMenuItem(
                                         value: 'edit',
                                         child: Text(strings.editSupplier),
                                       ),
                                       PopupMenuItem(
                                         value: 'delete',
                                         child: Row(
                                           children: [
                                             const Icon(
                                               Icons.delete_outline_rounded,
                                               size: 18,
                                               color: AppColors.dangerFg,
                                             ),
                                             const SizedBox(width: 8),
                                             Text(
                                               strings.deleteSupplier,
                                               style: const TextStyle(
                                                 color: AppColors.dangerFg,
                                               ),
                                             ),
                                           ],
                                         ),
                                       ),
                                     ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => SupplierDetailScreen(
                                      supplierId: supplier.id,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
