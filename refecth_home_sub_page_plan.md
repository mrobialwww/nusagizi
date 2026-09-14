# Implementation Plan: Auto-Refetch DevelopmentPage

## Problem
Ketika user dari `DevelopmentPage` (router L344) → `KpspAssessmentPage` (router L362) → kembali ke `DevelopmentPage`, data tidak di-refetch ulang.

## Current State
- `DevelopmentPage` belum punya `WidgetsBindingObserver`, router listener, atau tab listener
- `NutritionPage` sudah punya `WidgetsBindingObserver` tapi belum ada router/tab listener untuk refetch
- `NoteMotherPage` dan `HomeMotherPage` sudah menerapkan full 3-layer listener

## Solution: Apply 3-Layer Listener Pattern + Debounce

### Masalah: Rapid-Fire Calls
Ketiga listener (`_onRouteChanged`, `_onTabChanged`, `didChangeAppLifecycleState`) bisa trigger dalam hitungan milidetik yang sama saat user kembali ke halaman, menghasilkan **2-3 API call hampir bersamaan** untuk data yang sama.

### Solusi: Timer Debounce
Gunakan **single Timer** di setiap page. Ketika ada trigger dari salah satu listener:
1. Cancel timer sebelumnya
2. Mulai timer baru (500ms)
3. Hanya refetch jika timer selesai tanpa ada trigger baru

```
Trigger 1 (route) → cancel timer lama, mulai timer 500ms
Trigger 2 (tab)   → cancel timer lama, mulai timer 500ms  (dalam <100ms)
Trigger 3 (lifecycle) → cancel timer lama, mulai timer 500ms (dalam <200ms)
... 500ms tanpa trigger lagi ...
→ _refetch() execute (hanya 1x call)
```

### Contoh pattern (berlaku untuk kedua page):
```dart
Timer? _refetchTimer;

void _scheduleRefetch() {
  _refetchTimer?.cancel();
  _refetchTimer = Timer(const Duration(milliseconds: 500), () {
    _refetch();
  });
}

// Semua listener panggil _scheduleRefetch() bukan _refetch() langsung
void _onRouteChanged() { ... _scheduleRefetch(); }
void _onTabChanged() { ... _scheduleRefetch(); }
void didChangeAppLifecycleState(...) { ... _scheduleRefetch(); }

// Dispose
_refetchTimer?.cancel();
```

---

## Solution: Apply 3-Layer Listener Pattern

### 1. Modifikasi `development_page.dart`

**Mixin**: Tambahkan `WidgetsBindingObserver`

**Variables**:
```dart
late final GoRouterDelegate _routerDelegate;
Timer? _refetchTimer;
```

**InitState**:
```dart
WidgetsBinding.instance.addObserver(this);
motherNavTabNotifier.addListener(_onTabChanged);
_routerDelegate = GoRouter.of(context).routerDelegate;
_routerDelegate.addListener(_onRouteChanged);
```

**Refetch functions**:
```dart
void _scheduleRefetch() {
  _refetchTimer?.cancel();
  _refetchTimer = Timer(const Duration(milliseconds: 500), () {
    _refetch();
  });
}

void _refetch() {
  if (!mounted) return;
  final cacheState = sl<ChildrenCacheCubit>().state;
  if (cacheState.isNotEmpty && _selectedChildIndex < cacheState.length) {
    _cubit.loadSummary(cacheState[_selectedChildIndex].id);
  }
}
```

**Listeners** (semua panggil `_scheduleRefetch()` bukan `_refetch()` langsung):
- `_onRouteChanged()`: Cek URL == `/home-mother/development` && tab == 0 → `_scheduleRefetch()`
- `_onTabChanged()`: Cek tab == 0 && URL cocok → `_scheduleRefetch()`
- `didChangeAppLifecycleState()`: Cek `resumed` && tab == 0 && URL cocok → `_scheduleRefetch()`

**Dispose**:
```dart
WidgetsBinding.instance.removeObserver(this);
motherNavTabNotifier.removeListener(_onTabChanged);
_routerDelegate.removeListener(_onRouteChanged);
_refetchTimer?.cancel();
_cubit.close();
```

### 2. Modifikasi `nutrition_page.dart`

Sudah ada `WidgetsBindingObserver` + `didChangeAppLifecycleState`. Tambahkan:

**Variables**:
```dart
late final GoRouterDelegate _routerDelegate;
Timer? _refetchTimer;
```

**InitState** (tambahkan setelah kode yang sudah ada):
```dart
motherNavTabNotifier.addListener(_onTabChanged);
_routerDelegate = GoRouter.of(context).routerDelegate;
_routerDelegate.addListener(_onRouteChanged);
```

**Refetch functions**:
```dart
void _scheduleRefetch() {
  _refetchTimer?.cancel();
  _refetchTimer = Timer(const Duration(milliseconds: 500), () {
    _refetch();
  });
}

void _refetch() {
  if (!mounted) return;
  final cacheState = sl<ChildrenCacheCubit>().state;
  if (cacheState.isNotEmpty && _selectedChildIndex < cacheState.length) {
    _nutritionTodayCubit.fetchNutritionToday(cacheState[_selectedChildIndex].id);
  }
}
```

**New listeners** (semua panggil `_scheduleRefetch()`):
- `_onRouteChanged()`: Cek URL == `/home-mother/nutrition` && tab == 0 → `_scheduleRefetch()`
- `_onTabChanged()`: Cek tab == 0 && URL cocok → `_scheduleRefetch()`

**Update `didChangeAppLifecycleState`** (panggil `_scheduleRefetch()` bukan `_refetch()`):
```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    _checkAndGenerate();
    if (motherNavTabNotifier.value == 0) {
      final location = _routerDelegate.currentConfiguration.uri.toString();
      if (location == '/home-mother/nutrition') {
        _scheduleRefetch();
      }
    }
  }
}
```

**Dispose** (tambahkan):
```dart
motherNavTabNotifier.removeListener(_onTabChanged);
_routerDelegate.removeListener(_onRouteChanged);
_refetchTimer?.cancel();
```

### 3. Files affected
- `lib/features/mother/development/presentation/pages/development_page.dart`
- `lib/features/mother/nutrition/presentation/pages/nutrition_page.dart`

### 4. Verification
1. DevelopmentPage → KPSP Assessment → Pop → data refresh
2. DevelopmentPage → History → Pop → data refresh
3. NutritionPage → Recipe Detail → Pop → data refresh
4. Tab switch away & back → data refresh
5. App minimize → resume → data refresh
