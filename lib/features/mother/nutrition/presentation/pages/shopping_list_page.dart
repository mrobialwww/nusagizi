import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/shopping_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/domain/entities/substitute_item_entity.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/shopping_list_cubit.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/cubit/shopping_list_state.dart';
import 'package:nusagizi/features/mother/nutrition/presentation/widgets/swap_bottom_sheet_content.dart';
import 'package:nusagizi/core/widgets/child_avatar.dart';

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class DisplayGroup {
  final String name;
  final String slot;
  final bool isExpandable;
  final List<ShoppingItemEntity> items;

  DisplayGroup({
    required this.name,
    required this.slot,
    required this.isExpandable,
    required this.items,
  });
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  late final ShoppingListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = sl<ShoppingListCubit>()..fetchDailyShop();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  String _formatChildName(String fullName) {
    // ^\S{1,2}\s+\S+ : Jika kata pertama 1 atau 2 karakter (misal "M", "M.", "Al"), ambil kata pertama & kedua
    // ^\S+           : Jika kata pertama lebih dari 2 karakter, ambil kata pertama saja
    final match = RegExp(r'^\S{1,2}\s+\S+|^\S+').firstMatch(fullName.trim());
    return match?.group(0) ?? fullName;
  }

  List<DisplayGroup> _buildGroups(List<ShoppingItemEntity> items) {
    final Map<String, List<ShoppingItemEntity>> grouped = {};
    for (final item in items) {
      final key = item.name.trim().toLowerCase();
      grouped.putIfAbsent(key, () => []).add(item);
    }

    return grouped.entries.map((entry) {
      final groupItems = entry.value;
      return DisplayGroup(
        name: groupItems.first.name,
        slot: groupItems.first.slot,
        isExpandable: groupItems.length > 1,
        items: groupItems,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const HeaderBasic(
          backgroundColor: Colors.white,
          title: "Daftar Belanja Hari Ini",
          subtitle: "1 Agustus 2026",
        ),
        body: BlocBuilder<ShoppingListCubit, ShoppingListState>(
          builder: (context, state) {
            if (state is ShoppingListLoading) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF00A735)),
              );
            } else if (state is ShoppingListError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.red)),
              );
            } else if (state is ShoppingListLoaded) {
              final displayGroups = _buildGroups(state.items);

              int checkedCount = 0;
              for (var group in displayGroups) {
                final key = group.name.trim().toLowerCase();
                if (state.checkedMap[key] == true) {
                  checkedCount++;
                }
              }
              final double progress = displayGroups.isEmpty
                  ? 0
                  : checkedCount / displayGroups.length;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$checkedCount dari ${displayGroups.length} bahan sudah dicentang",
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      color: const Color(0xFF00A735),
                      minHeight: 6.h,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      "Ketuk > untuk lihat rincian per anak. Ketuk Tukar untuk ganti bahan.",
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildShoppingList(displayGroups, state),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildShoppingList(
    List<DisplayGroup> displayGroups,
    ShoppingListLoaded state,
  ) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: displayGroups.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final group = displayGroups[index];
        if (group.isExpandable) {
          return _buildExpandableShoppingCard(group, state);
        } else {
          return _buildStandardShoppingCard(group, state);
        }
      },
    );
  }

  Widget _buildStandardShoppingCard(
    DisplayGroup group,
    ShoppingListLoaded state,
  ) {
    final item = group.items.first;

    // Show substitute if item is swapped (priority > 1) or in a shared slot
    final bool isSwapped = item.priority > 1;
    final bool isSharedSlot = state.items.any(
      (i) => i.slot == item.slot && i.childName != item.childName,
    );
    final bool showSubtitle = isSwapped || isSharedSlot;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCF9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            _buildCheckbox(group.name, state.checkedMap),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  if (showSubtitle)
                    Text(
                      "untuk ${_formatChildName(item.childName)}",
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00A735),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                item.unit,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            if (item.substitutes.isNotEmpty) ...[
              SizedBox(width: 12.w),
              _buildTukarButton(context, [item], state.swapLoadingMap),
            ],
          ],
        ),
      ),
    );
  }

  String _calculateTotalQuantity(List<ShoppingItemEntity> items) {
    double totalGrams = 0;
    double totalPieces = 0;
    String pieceUnit = "";

    final RegExp gramRegex = RegExp(r'(\d+(?:\.\d+)?)\s*g');
    final RegExp pieceRegex = RegExp(r'(\d+(?:\.\d+)?)\s*([a-zA-Z]+)');

    for (var item in items) {
      final unitStr = item.unit;

      final gramMatch = gramRegex.firstMatch(unitStr);
      if (gramMatch != null) {
        totalGrams += double.tryParse(gramMatch.group(1) ?? '0') ?? 0;
      }

      final pieceMatch = pieceRegex.firstMatch(unitStr);
      if (pieceMatch != null) {
        final extractedUnit = pieceMatch.group(2) ?? '';
        // Hindari mencocokkan 'g' atau 'gram' sebagai pieceUnit
        if (extractedUnit.toLowerCase() != 'g' &&
            extractedUnit.toLowerCase() != 'gram') {
          totalPieces += double.tryParse(pieceMatch.group(1) ?? '0') ?? 0;
          pieceUnit = extractedUnit;
        }
      }
    }

    List<String> parts = [];
    if (totalPieces > 0) {
      String str = totalPieces.toStringAsFixed(2);
      if (str.endsWith('.00')) {
        str = str.substring(0, str.length - 3);
      } else if (str.endsWith('0')) {
        str = str.substring(0, str.length - 1);
      }
      parts.add("$str $pieceUnit");
    }
    if (totalGrams > 0) {
      String str = totalGrams.toStringAsFixed(2);
      if (str.endsWith('.00')) {
        str = str.substring(0, str.length - 3);
      } else if (str.endsWith('0')) {
        str = str.substring(0, str.length - 1);
      }
      if (parts.isNotEmpty) {
        parts.add("(${str}g)");
      } else {
        parts.add("${str}g");
      }
    }

    return parts.join(' ');
  }

  Widget _buildExpandableShoppingCard(
    DisplayGroup group,
    ShoppingListLoaded state,
  ) {
    final uniqueChildren = group.items.map((i) => i.childName).toSet().toList();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFCFCF9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          iconColor: Colors.grey.shade600,
          collapsedIconColor: Colors.grey.shade600,
          title: Row(
            children: [
              _buildCheckbox(group.name, state.checkedMap),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.name,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      _calculateTotalQuantity(group.items),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: uniqueChildren.map((childName) {
                  return Container(
                    margin: EdgeInsets.only(left: 3.w),
                    child: ChildAvatar(name: childName, size: 20),
                  );
                }).toList(),
              ),
            ],
          ),
          children: () {
            final Map<String, List<ShoppingItemEntity>> childGroups = {};
            for (var item in group.items) {
              childGroups.putIfAbsent(item.childName, () => []).add(item);
            }

            return childGroups.entries.map((entry) {
              final childName = entry.key;
              final childItems = entry.value;
              final displayUnit = childItems.length == 1
                  ? childItems.first.unit
                  : _calculateTotalQuantity(childItems);
              final hasSubstitutes = childItems.any(
                (i) => i.substitutes.isNotEmpty,
              );

              return Padding(
                padding: EdgeInsets.only(left: 24.w, right: 16.w, bottom: 12.h),
                child: Row(
                  children: [
                    ChildAvatar(name: childName, size: 20),
                    SizedBox(width: 10.w),
                    Text(
                      _formatChildName(childName),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        displayUnit,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                    if (hasSubstitutes) ...[
                      SizedBox(width: 10.w),
                      _buildTukarButton(
                        context,
                        childItems,
                        state.swapLoadingMap,
                      ),
                    ],
                  ],
                ),
              );
            }).toList();
          }(),
        ),
      ),
    );
  }

  Widget _buildCheckbox(String name, Map<String, bool> checkedMap) {
    final key = name.trim().toLowerCase();
    final isChecked = checkedMap[key] ?? false;

    return GestureDetector(
      onTap: () {
        _cubit.toggleItemCheck(key);
      },
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: isChecked ? const Color(0xFF00A735) : Colors.transparent,
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isChecked ? const Color(0xFF00A735) : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        child: isChecked
            ? Icon(Icons.check, color: Colors.white, size: 18.sp)
            : null,
      ),
    );
  }

  Widget _buildTukarButton(
    BuildContext context,
    List<ShoppingItemEntity> childItems,
    Map<String, bool> swapLoadingMap,
  ) {
    if (childItems.isEmpty) return const SizedBox.shrink();

    final firstItem = childItems.first;
    final swapKey = '${firstItem.name}_${firstItem.childName}';
    final isLoading = swapLoadingMap[swapKey] ?? false;

    // Deduplicate substitutes by name
    final uniqueSubNames = <String>{};
    final displaySubs = <SubstituteItemEntity>[];
    for (final item in childItems) {
      for (final sub in item.substitutes) {
        final lowerName = sub.name.trim().toLowerCase();
        if (uniqueSubNames.add(lowerName)) {
          displaySubs.add(sub);
        }
      }
    }

    final amountText = childItems.length == 1
        ? firstItem.unit
        : _calculateTotalQuantity(childItems);

    return GestureDetector(
      onTap: isLoading
          ? null
          : () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                builder: (context) {
                  return SwapBottomSheetContent(
                    itemName: firstItem.name,
                    amount: amountText,
                    childName: firstItem.childName,
                    options: displaySubs,
                    onSwapConfirmed: (selectedSubstituteName) {
                      _cubit.swapIngredient(childItems, selectedSubstituteName);
                    },
                  );
                },
              );
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: const Color(0xFFE5F6EB),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF00A735),
                ),
              )
            else
              Icon(
                Icons.swap_horiz,
                color: const Color(0xFF00A735),
                size: 16.w,
              ),
            SizedBox(width: 4.w),
            Text(
              isLoading ? "Memproses..." : "Tukar",
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF00A735),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
