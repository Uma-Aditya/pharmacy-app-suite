"""Inventory adapter alias for outward sales report scanning.

Re-exports the shared inventory integration adapter logic.
"""

from app.modules.suppliers_purchase_orders.inventory_adapter import (
    BatchAllocationDetail,
    BatchBalance,
    InwardItemInput,
    InwardStockRequest,
    InwardStockResult,
    OutwardLineInput,
    OutwardStockRequest,
    OutwardStockResult,
    ProductStockBalance,
    ReconciliationItem,
    ReconciliationReport,
    StockMovementRecord,
    InventoryService,
    InMemoryInventoryStore,
    fallback_inventory_store,
    is_date_expired,
)

__all__ = [
    "BatchAllocationDetail",
    "BatchBalance",
    "InwardItemInput",
    "InwardStockRequest",
    "InwardStockResult",
    "OutwardLineInput",
    "OutwardStockRequest",
    "OutwardStockResult",
    "ProductStockBalance",
    "ReconciliationItem",
    "ReconciliationReport",
    "StockMovementRecord",
    "InventoryService",
    "InMemoryInventoryStore",
    "fallback_inventory_store",
    "is_date_expired",
]

