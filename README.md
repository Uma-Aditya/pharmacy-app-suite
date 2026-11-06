# MediShop Pharmacy Application Suite

A unified multi-module pharmacy management platform built with **FastAPI** (async PostgreSQL) and **Flutter** (Web / Desktop / Mobile).

---

## Repository Structure

This repository brings together three independent feature applications with **strict feature isolation (Option B)**, preserving domain autonomy for each module while sharing consistent UI, auth, and backend design:

```text
PharmaFinal/
├── pharmacy-app-catalogue/        # Member 2: Catalogue Search, Drug Index & Unit Conversions
│   └── pharmacy-app-catalogue/
│       ├── backend/               # FastAPI backend with /api/products endpoints
│       └── frontend/              # Flutter frontend (Catalogue module active)
│
├── pharmacy-app-outward/          # Member 7: Outward Sales, Barcode Scanning & Daily Reports
│   └── pharmacy-app-outward/
│       ├── backend/               # FastAPI backend with /api/sales-reports endpoints
│       └── frontend/              # Flutter frontend (Outward Sales module active)
│
├── pharmacy-app-supplier/         # Member 3: Suppliers, Vendor Catalogs & Purchase Orders
│   └── pharmacy-app-supplier/
│       ├── backend/               # FastAPI backend with /api/stores/{id}/suppliers endpoints
│       └── frontend/              # Flutter frontend (Suppliers & PO module active)
│
├── .gitignore                     # Repository-level ignore rules
└── README.md                      # Monorepo documentation
```

---

## Feature Isolation Matrix (Option B)

In accordance with feature assignment specifications, each application isolates its assigned domain feature. The navigation shell remains consistent across all apps, while non-assigned features render clean placeholders (`ModulePlaceholderScreen`):

| Application Folder | Domain Owner | Active Feature Module | Placeholder Modules |
| :--- | :--- | :--- | :--- |
| **`pharmacy-app-catalogue`** | Member 2 | **Catalogue Search & Units** (`/api/products`) | Suppliers (M3), Outward Sales (M7) |
| **`pharmacy-app-outward`** | Member 7 | **Outward Sales & Scanning** (`/api/sales-reports`) | Catalogue (M2), Suppliers (M3) |
| **`pharmacy-app-supplier`** | Member 3 | **Suppliers & Purchase Orders** (`/api/stores/{id}/suppliers`, `/purchase-orders`) | Catalogue (M2), Outward Sales (M7) |

---

## Tech Stack

- **Backend:** Python 3.12, FastAPI, SQLAlchemy 2.0 (async), PostgreSQL + asyncpg, Pydantic v2, Argon2 password hashing, Pytest.
- **Frontend:** Flutter 3.29+ / Dart 3.7+, Riverpod state management, GoRouter, Material 3 design system with contrast-accessible tokens.

---

## Quick Start Guide

### Prerequisites
- Python 3.11+
- Flutter SDK (3.24+)
- PostgreSQL 15+ running locally (default database: `pharmacy_store_dev`)

### 1. Database Setup
Ensure PostgreSQL is running and the database exists:
```sql
CREATE DATABASE pharmacy_store_dev;
```

### 2. Backend Setup (Example: Catalogue Module)
Navigate to the desired module's backend directory:
```bash
cd pharmacy-app-catalogue/pharmacy-app-catalogue/backend

# Create virtual environment and install dependencies
python -m venv .venv
source .venv/bin/activate  # On Windows: .venv\Scripts\Activate.ps1
pip install -r requirements.txt

# Copy environment template if needed
cp .env.example .env

# Initialize schema and seed demo records
python scripts/init_db.py
python scripts/seed_demo.py

# Launch FastAPI server
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```
API Documentation will be accessible at: `http://localhost:8000/docs`

### 3. Frontend Setup
Navigate to the corresponding frontend directory:
```bash
cd pharmacy-app-catalogue/pharmacy-app-catalogue/frontend

# Install Flutter dependencies
flutter pub get

# Run on Chrome
flutter run -d chrome --web-port 8080
```

---

## Demo Accounts & Credentials

The seed script initializes role-based demo accounts:

| Role | Username / Phone | Password | Capabilities |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `superadmin@medishop.local` | `Admin@123456` | Global store oversight, tenant management |
| **Store Owner** | `+919876512345` | `Owner@123456` | Full store configuration, reports, catalogue, inventory |
| **Pharmacist** | `+919876523456` | `Staff@123456` | Dispensing, stock check, catalogue lookups |
| **Cashier** | `+919876534567` | `Staff@123456` | POS scanning, outward sales billing |

---

## Test Verification

All backends and frontends are validated with automated test suites:
- **Backend:** `pytest tests/` (100% pass rate across all 174 unit and integration tests)
- **Frontend:** `flutter test test/three_modules_test.dart test/contrast_test.dart` (14/14 widget & contrast tests passing)
