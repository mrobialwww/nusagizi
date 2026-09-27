import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/edit_child_profile_helpers.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';

class AddEditChildProfileStep2 extends StatefulWidget {
  const AddEditChildProfileStep2({super.key});

  @override
  State<AddEditChildProfileStep2> createState() =>
      _AddEditChildProfileStep2State();
}

class _AddEditChildProfileStep2State extends State<AddEditChildProfileStep2> {
  String _alergiMakanan = 'Tidak';
  String _kondisiKronis = 'Tidak';
  String _dietKhusus = 'Tidak';

  late TextEditingController _foodAllergyCtrl;
  late TextEditingController _medicineAllergyCtrl;
  late TextEditingController _animalAllergyCtrl;
  late TextEditingController _otherAllergyCtrl;
  late TextEditingController _chronicDiseaseCtrl;
  late TextEditingController _dietCtrl;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AddEditProfileCubit>();

    final allergies = cubit.state.allergies;
    _foodAllergyCtrl = TextEditingController(
      text: allergies['food']?.join(', ') ?? '',
    );
    _medicineAllergyCtrl = TextEditingController(
      text: allergies['medicine']?.join(', ') ?? '',
    );
    _animalAllergyCtrl = TextEditingController(
      text: allergies['animal']?.join(', ') ?? '',
    );
    _otherAllergyCtrl = TextEditingController(
      text: allergies['other']?.join(', ') ?? '',
    );

    _alergiMakanan = allergies.isNotEmpty ? 'Ada' : 'Tidak';

    _chronicDiseaseCtrl = TextEditingController(
      text: cubit.state.chronicDiseases.join(', '),
    );
    _kondisiKronis = cubit.state.chronicDiseases.isNotEmpty ? 'Ada' : 'Tidak';

    _dietCtrl = TextEditingController(text: cubit.state.diets.join(', '));
    _dietKhusus = cubit.state.diets.isNotEmpty ? 'Ada' : 'Tidak';
  }

  @override
  void dispose() {
    _foodAllergyCtrl.dispose();
    _medicineAllergyCtrl.dispose();
    _animalAllergyCtrl.dispose();
    _otherAllergyCtrl.dispose();
    _chronicDiseaseCtrl.dispose();
    _dietCtrl.dispose();
    super.dispose();
  }

  void _updateCubit() {
    final cubit = context.read<AddEditProfileCubit>();

    Map<String, List<String>> newAllergies = {};
    if (_alergiMakanan == 'Ada') {
      if (_foodAllergyCtrl.text.isNotEmpty) {
        newAllergies['food'] = _foodAllergyCtrl.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
      if (_medicineAllergyCtrl.text.isNotEmpty) {
        newAllergies['medicine'] = _medicineAllergyCtrl.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
      if (_animalAllergyCtrl.text.isNotEmpty) {
        newAllergies['animal'] = _animalAllergyCtrl.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
      if (_otherAllergyCtrl.text.isNotEmpty) {
        newAllergies['other'] = _otherAllergyCtrl.text
            .split(',')
            .map((e) => e.trim())
            .toList();
      }
    }

    List<String> newChronicDiseases = [];
    if (_kondisiKronis == 'Ada' && _chronicDiseaseCtrl.text.isNotEmpty) {
      newChronicDiseases = _chronicDiseaseCtrl.text
          .split(',')
          .map((e) => e.trim())
          .toList();
    }

    List<String> newDiets = [];
    if (_dietKhusus == 'Ada' && _dietCtrl.text.isNotEmpty) {
      newDiets = _dietCtrl.text.split(',').map((e) => e.trim()).toList();
    }

    cubit.updateStep2(
      allergies: newAllergies,
      chronicDiseases: newChronicDiseases,
      diets: newDiets,
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
          buildStepHeader('Langkah 2', 'Riwayat Kesehatan & Alergi'),
          SizedBox(height: 32.h),
          buildLabel('Ada alergi makanan?', isRequired: true),
          RadioGroup<String>(
            groupValue: _alergiMakanan,
            onChanged: (val) {
              if (val != null) {
                setState(() => _alergiMakanan = val);
                _updateCubit();
              }
            },
            child: Row(
              children: [
                buildRadioItem('Ada'),
                SizedBox(width: 24.w),
                buildRadioItem('Tidak'),
              ],
            ),
          ),
          if (_alergiMakanan == 'Ada') _buildAlergiDetails(),

          SizedBox(height: 24.h),
          buildLabel('Ada kondisi kronis?', isRequired: true),
          RadioGroup<String>(
            groupValue: _kondisiKronis,
            onChanged: (val) {
              if (val != null) {
                setState(() => _kondisiKronis = val);
                _updateCubit();
              }
            },
            child: Row(
              children: [
                buildRadioItem('Ada'),
                SizedBox(width: 24.w),
                buildRadioItem('Tidak'),
              ],
            ),
          ),
          if (_kondisiKronis == 'Ada') _buildKronisDetails(),

          SizedBox(height: 24.h),
          buildLabel('Ada diet khusus?', isRequired: true),
          RadioGroup<String>(
            groupValue: _dietKhusus,
            onChanged: (val) {
              if (val != null) {
                setState(() => _dietKhusus = val);
                _updateCubit();
              }
            },
            child: Row(
              children: [
                buildRadioItem('Ada'),
                SizedBox(width: 24.w),
                buildRadioItem('Tidak'),
              ],
            ),
          ),
          if (_dietKhusus == 'Ada') _buildDietDetails(),
        ],
      ),
    );
  }

  Widget _buildDetailBox(
    String label,
    String hint,
    TextEditingController controller,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          TextFormField(
            controller: controller,
            onChanged: (val) => _updateCubit(),
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.black87,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.grey.shade400,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: const BorderSide(color: Color(0xFF00A735)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlergiDetails() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _buildDetailBox('Makanan', 'Contoh: kacang, telur', _foodAllergyCtrl),
          _buildDetailBox(
            'Obat-obatan',
            'Contoh: penisilin',
            _medicineAllergyCtrl,
          ),
          _buildDetailBox('Binatang', 'Contoh: kucing', _animalAllergyCtrl),
          _buildDetailBox('Lainnya', 'Contoh: debu', _otherAllergyCtrl),
        ],
      ),
    );
  }

  Widget _buildKronisDetails() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: _buildDetailBox(
        'Kondisi Kronis',
        'Contoh: Diabetes, PJB',
        _chronicDiseaseCtrl,
      ),
    );
  }

  Widget _buildDietDetails() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(top: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: _buildDetailBox('Jenis Diet', 'Contoh: TETP', _dietCtrl),
    );
  }
}
