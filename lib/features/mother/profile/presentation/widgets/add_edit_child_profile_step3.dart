import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/edit_child_profile_helpers.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';

class AddEditChildProfileStep3 extends StatefulWidget {
  const AddEditChildProfileStep3({super.key});

  @override
  State<AddEditChildProfileStep3> createState() =>
      _AddEditChildProfileStep3State();
}

class _AddEditChildProfileStep3State extends State<AddEditChildProfileStep3> {
  final List<String> _makananFavorit = [
    'Ayam',
    'Telur',
    'Buah',
    'Roti',
    'Nasi',
    'Ikan',
    'Sayur',
  ];
  List<String> _selectedMakanan = [];

  final List<String> _teksturFavorit = [
    'Bubur halus',
    'Makanan lembut',
    'Potongan kecil',
    'Finger food',
    'Makanan Keluarga',
  ];
  List<String> _selectedTekstur = [];

  bool _isLainnyaMakananSelected = false;
  bool _isLainnyaTeksturSelected = false;

  late TextEditingController _notesCtrl;
  late TextEditingController _otherMakananCtrl;
  late TextEditingController _otherTeksturCtrl;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AddEditProfileCubit>();
    _selectedMakanan = List.from(cubit.state.favoriteFoods);
    _selectedTekstur = List.from(cubit.state.favoriteTextures);
    _notesCtrl = TextEditingController(text: cubit.state.notes ?? '');

    // Determine if we need to check the 'Lainnya' chip based on items not in the default list
    final otherMakanan = _selectedMakanan
        .where((e) => !_makananFavorit.contains(e))
        .toList();
    if (otherMakanan.isNotEmpty) {
      _isLainnyaMakananSelected = true;
      _selectedMakanan.removeWhere((e) => !_makananFavorit.contains(e));
    }
    _otherMakananCtrl = TextEditingController(text: otherMakanan.join(', '));

    final otherTekstur = _selectedTekstur
        .where((e) => !_teksturFavorit.contains(e))
        .toList();
    if (otherTekstur.isNotEmpty) {
      _isLainnyaTeksturSelected = true;
      _selectedTekstur.removeWhere((e) => !_teksturFavorit.contains(e));
    }
    _otherTeksturCtrl = TextEditingController(text: otherTekstur.join(', '));
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _otherMakananCtrl.dispose();
    _otherTeksturCtrl.dispose();
    super.dispose();
  }

  void _updateCubit() {
    final cubit = context.read<AddEditProfileCubit>();

    List<String> finalMakanan = List.from(_selectedMakanan);
    if (_isLainnyaMakananSelected && _otherMakananCtrl.text.isNotEmpty) {
      finalMakanan.addAll(
        _otherMakananCtrl.text.split(',').map((e) => e.trim()),
      );
    }

    List<String> finalTekstur = List.from(_selectedTekstur);
    if (_isLainnyaTeksturSelected && _otherTeksturCtrl.text.isNotEmpty) {
      finalTekstur.addAll(
        _otherTeksturCtrl.text.split(',').map((e) => e.trim()),
      );
    }

    cubit.updateStep3(
      favoriteFoods: finalMakanan,
      favoriteTextures: finalTekstur,
      notes: _notesCtrl.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildStepHeader('Langkah 3', 'Preferensi & Tujuan (Opsional)'),
          SizedBox(height: 24.h),
          buildPreferencesSection(
            title: 'Makanan Favorit',
            availableItems: _makananFavorit,
            selectedItems: _selectedMakanan,
            isOtherSelected: _isLainnyaMakananSelected,
            onItemToggled: (item) {
              setState(() {
                if (_selectedMakanan.contains(item)) {
                  _selectedMakanan.remove(item);
                } else {
                  _selectedMakanan.add(item);
                }
              });
              _updateCubit();
            },
            onOtherToggled: () {
              setState(() {
                _isLainnyaMakananSelected = !_isLainnyaMakananSelected;
              });
              _updateCubit();
            },
            otherHint: 'Contoh: kentang, ubi',
            otherController: _otherMakananCtrl,
            onOtherChanged: _updateCubit,
          ),
          buildPreferencesSection(
            title: 'Tekstur Favorit',
            availableItems: _teksturFavorit,
            selectedItems: _selectedTekstur,
            isOtherSelected: _isLainnyaTeksturSelected,
            onItemToggled: (item) {
              setState(() {
                if (_selectedTekstur.contains(item)) {
                  _selectedTekstur.remove(item);
                } else {
                  _selectedTekstur.add(item);
                }
              });
              _updateCubit();
            },
            onOtherToggled: () {
              setState(() {
                _isLainnyaTeksturSelected = !_isLainnyaTeksturSelected;
              });
              _updateCubit();
            },
            otherHint: 'Contoh: Makanan keluarga',
            otherController: _otherTeksturCtrl,
            onOtherChanged: _updateCubit,
          ),
          Text(
            'Catatan Khusus',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: _notesCtrl,
            onChanged: (val) => _updateCubit(),
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Saya mau menu yang bahannya murah dan mudah didapat',
              hintStyle: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.grey,
                fontWeight: FontWeight.w500,
                fontSize: 13.sp,
              ),
              contentPadding: EdgeInsets.all(16.w),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(color: Color(0xFF00A735)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
