# Refetch v2: On-CRUD Only

## Problem
Mekanisme 3-layer listener (route + tab + lifecycle) terlalu agresif — refetch setiap kali user berpindah halaman, padahal data mungkin tidak berubah.

## Goal
Refetch **hanya ketika ada operasi Create/Update/Delete** yang terjadi di child pages (KPSP Assessment, Checklist, Growth Report, dll).

## Concept

```
DevelopmentPage (parent)
  ├── KPSP Assessment (child) → submit/update assessment → set _hasCrud = true
  ├── Checklist (child) → update checklist → tidak perlu refetch (sudah sync langsung)
  └── History (child) → tidak ada CRUD → _hasCrud tetap false

User kembali ke DevelopmentPage
  → cek _hasCrud
  → jika true → refetch + reset flag
  → jika false → skip (tidak perlu refetch)
```

## Architecture: Shared CRUD Flag

### Flag global

```dart
/// Flag untuk menandai apakah ada operasi CRUD yang terjadi.
/// Child pages set true setelah CRUD, parent pages check dan reset.
bool crudFlag = false;
```

Tidak perlu file terpisah. Cukup declare sebagai top-level variable di file yang membutuhkan, atau di satu tempat yang sudah di-import semua page (misalnya `service_locator.dart`).

### Cara Kerja

1. **Child page** (KPSP Assessment, dll) — setelah operasi CRUD berhasil:
   ```dart
   crudFlag = true;
   ```

2. **Parent page** (DevelopmentPage, NutritionPage, GrowthPage) — saat route berubah:
   ```dart
   void _onRouteChanged() {
     if (!mounted) return;
     try {
       final location = _routerDelegate.currentConfiguration.uri.toString();
       if (location == '/home-mother/development' && motherNavTabNotifier.value == 0) {
         if (crudFlag) {
           _refetch();
           crudFlag = false;
         }
       }
     } catch (_) {}
   }
   ```

---

## Changes per Page

### 1. `development_page.dart`

**Hapus**: Timer debounce, `_scheduleRefetch()`, listener tab, listener lifecycle

**Simpan**: Hanya `_onRouteChanged()` + cek `crudFlag`

```dart
// Variables (dipertahankan)
late final GoRouterDelegate _routerDelegate;

// initState
_routerDelegate = GoRouter.of(context).routerDelegate;
_routerDelegate.addListener(_onRouteChanged);

// Hanya route listener yang diperlukan
void _onRouteChanged() {
  if (!mounted) return;
  try {
    final location = _routerDelegate.currentConfiguration.uri.toString();
    if (location == '/home-mother/development' && motherNavTabNotifier.value == 0) {
      if (crudFlag) {
        _refetch();
        crudFlag = false;
      }
    }
  } catch (_) {}
}

// _refetch tetap sama
void _refetch() {
  if (!mounted) return;
  final cacheState = sl<ChildrenCacheCubit>().state;
  if (cacheState.isNotEmpty && _selectedChildIndex < cacheState.length) {
    _cubit.loadSummary(cacheState[_selectedChildIndex].id);
  }
}

// dispose
_routerDelegate.removeListener(_onRouteChanged);
```

**Dihapus**: `WidgetsBindingObserver`, `_onTabChanged`, `didChangeAppLifecycleState`, `Timer? _refetchTimer`, `_scheduleRefetch()`

### 2. `nutrition_page.dart`

Sama seperti development_page — hanya route listener + cek `crudFlag`.

**Dihapus**: `_onTabChanged`, `didChangeAppLifecycleState` (untuk refetch), `Timer? _refetchTimer`, `_scheduleRefetch()`

**Dipertahankan**: `didChangeAppLifecycleState` hanya untuk `_checkAndGenerate()` (midnight sync), bukan untuk refetch.

### 3. `growth_page.dart`

Terapkan pola sama: route listener + cek `crudFlag`.

### 4. Child Pages yang perlu set `crudFlag = true`

| Page | Operasi CRUD |
|------|-------------|
| `kpsp_assessment_page.dart` | Submit/update KPSP assessment |
| `add_growth_page.dart` | Add growth report |
| `kpsp_result_page.dart` | Jika ada retake assessment |

**Tidak perlu set flag:**
- `checklist_milestone_page.dart` — checklist bersifat inkremental, perubahan sudah tersync langsung ke server via debounce. Tidak perlu refetch summary saat kembali.

---

## Files Affected

### Update
- `lib/features/mother/development/presentation/pages/development_page.dart`
- `lib/features/mother/nutrition/presentation/pages/nutrition_page.dart`
- `lib/features/mother/growth/presentation/pages/growth_page.dart`
- `lib/features/mother/development/presentation/pages/kpsp_assessment_page.dart`
- `lib/features/mother/growth/presentation/pages/add_growth_page.dart`

---

## Kelebihan vs 3-Layer Listener

| Aspek | 3-Layer Listener (v1) | CRUD Flag (v2) |
|-------|----------------------|----------------|
| API call saat tidak ada perubahan | Sering (setiap navigasi) | Tidak ada |
| Kompleksitas | Tinggi (3 listener + debounce) | Rendah (1 listener + 1 flag) |
| Boilerplate | ~40 baris per page | ~15 baris per page |
| Risk double fetch | Perlu debounce | Tidak ada |
| Akurasi | Selalu refetch | Hanya saat ada perubahan |

---

## Verification

1. DevelopmentPage → KPSP Assessment → submit → Pop → data refresh ✓
2. DevelopmentPage → KPSP Assessment → batal (tidak submit) → Pop → data TIDAK refresh ✓
3. DevelopmentPage → Checklist → toggle item → Pop → data TIDAK refresh ✓
4. DevelopmentPage → History → Pop → data TIDAK refresh ✓
5. NutritionPage → Generate Menu → data refresh ✓
6. GrowthPage → Add Report → Pop → data refresh ✓
7. Tab switch → data TIDAK refresh (karena tidak ada CRUD) ✓
