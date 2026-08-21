import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
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
          Text(
            'Makanan Favorit',
            style: GoogleFonts.outfit(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              ..._makananFavorit.map(
                (item) => buildChip(item, _selectedMakanan.contains(item), () {
                  setState(() {
                    if (_selectedMakanan.contains(item)) {
                      _selectedMakanan.remove(item);
                    } else {
                      _selectedMakanan.add(item);
                    }
                  });
                  _updateCubit();
                }),
              ),
              buildChip('+ Lainnya', _isLainnyaMakananSelected, () {
                setState(() {
                  _isLainnyaMakananSelected = !_isLainnyaMakananSelected;
                });
                _updateCubit();
              }),
            ],
          ),
          if (_isLainnyaMakananSelected) ...[
            SizedBox(height: 16.h),
            _buildOtherBox('Contoh: kentang, ubi', _otherMakananCtrl),
          ],
          SizedBox(height: 24.h),

          Text(
            'Tekstur Favorit',
            style: GoogleFonts.outfit(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._teksturFavorit.map(
                (item) => buildChip(item, _selectedTekstur.contains(item), () {
                  setState(() {
                    if (_selectedTekstur.contains(item)) {
                      _selectedTekstur.remove(item);
                    } else {
                      _selectedTekstur.add(item);
                    }
                  });
                  _updateCubit();
                }),
              ),
              buildChip('+ Lainnya', _isLainnyaTeksturSelected, () {
                setState(() {
                  _isLainnyaTeksturSelected = !_isLainnyaTeksturSelected;
                });
                _updateCubit();
              }),
            ],
          ),
          if (_isLainnyaTeksturSelected) ...[
            SizedBox(height: 16.h),
            _buildOtherBox('Contoh: Makanan keluarga', _otherTeksturCtrl),
          ],
          SizedBox(height: 24.h),
          Text(
            'Catatan Khusus',
            style: GoogleFonts.outfit(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
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
              hintStyle: GoogleFonts.outfit(
                color: Colors.grey,
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

  Widget _buildOtherBox(String hint, TextEditingController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lainnya',
            style: GoogleFonts.outfit(
              color: Colors.grey.shade600,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            onChanged: (val) => _updateCubit(),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(
                color: Colors.grey.shade400,
                fontSize: 13.sp,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 10.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: const BorderSide(color: Color(0xFF00A735)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.r),
                borderSide: const BorderSide(
                  color: Color(0xFF00A735),
                  width: 1.5,
                ),
              ),
            ),
            style: GoogleFonts.outfit(color: Colors.black87, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
