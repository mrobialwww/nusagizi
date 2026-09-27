import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/core/widgets/calendar/custom_date_picker_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/domain/entities/child_header_entity.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/note/data/models/medical_note_request_model.dart';
import 'package:nusagizi/features/mother/note/domain/entities/medical_note_detail_entity.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/add_edit_note_cubit.dart';
import 'package:nusagizi/features/mother/note/presentation/cubit/add_edit_note_state.dart';
import 'package:nusagizi/core/utils/number_extension.dart';

class AddOrEditNotePage extends StatefulWidget {
  final MedicalNoteDetailEntity? noteToEdit;

  const AddOrEditNotePage({super.key, this.noteToEdit});

  @override
  State<AddOrEditNotePage> createState() => _AddOrEditNotePageState();
}

class _AddOrEditNotePageState extends State<AddOrEditNotePage> {
  ChildHeaderEntity? _selectedChild;
  List<ChildHeaderEntity> _children = [];
  final List<String> _pantanganList = [];
  final List<String> _alergenList = [];

  final TextEditingController _doctorNameCtrl = TextEditingController();
  final TextEditingController _clinicNameCtrl = TextEditingController();
  final TextEditingController _recommendationCtrl = TextEditingController();
  final TextEditingController _pantanganCtrl = TextEditingController();
  final TextEditingController _alergenCtrl = TextEditingController();

  double _calories = 0.0, _protein = 0.0, _fat = 0.0, _carbs = 0.0;

  DateTime? _validDate;

  @override
  void initState() {
    super.initState();
    _loadChildren();
    if (widget.noteToEdit != null) {
      _prefillData(widget.noteToEdit!);
    }
  }

  void _loadChildren() {
    final cacheState = sl<ChildrenCacheCubit>().state;
    _children = cacheState;
    if (widget.noteToEdit != null) {
      // Edit mode: find child by name to preselect in the dropdown
      try {
        _selectedChild = _children.firstWhere(
          (c) =>
              c.name.toLowerCase() ==
              widget.noteToEdit!.childName.toLowerCase(),
        );
      } catch (_) {}
    } else {
      // Add mode: preselect the first child in the dropdown by default
      if (_children.isNotEmpty) {
        _selectedChild = _children.first;
      }
    }
  }

  void _prefillData(MedicalNoteDetailEntity note) {
    _doctorNameCtrl.text = note.doctorName;
    _clinicNameCtrl.text = note.facilityName ?? '';
    _recommendationCtrl.text = note.recommendation;

    _validDate = note.validDate;

    for (var target in note.dailyNutritionTargets) {
      switch (target.nutrient.toLowerCase()) {
        case 'calorie':
          _calories = target.quantity.toDouble();
        case 'protein':
          _protein = target.quantity.toDouble();
        case 'fat':
          _fat = target.quantity.toDouble();
        case 'carbohydrate':
          _carbs = target.quantity.toDouble();
      }
    }

    for (var rest in note.medicalRestrictions) {
      switch (rest.type.toLowerCase()) {
        case 'prohibition':
          _pantanganList.add(rest.restrictionName);
        case 'allergy':
          _alergenList.add(rest.restrictionName);
      }
    }
  }

  @override
  void dispose() {
    _doctorNameCtrl.dispose();
    _clinicNameCtrl.dispose();
    _recommendationCtrl.dispose();
    _pantanganCtrl.dispose();
    _alergenCtrl.dispose();
    super.dispose();
  }

  void _addPantangan() {
    if (_pantanganCtrl.text.trim().isNotEmpty) {
      setState(() {
        _pantanganList.add(_pantanganCtrl.text.trim());
        _pantanganCtrl.clear();
      });
    }
  }

  void _addAlergen() {
    if (_alergenCtrl.text.trim().isNotEmpty) {
      setState(() {
        _alergenList.add(_alergenCtrl.text.trim());
        _alergenCtrl.clear();
      });
    }
  }

  void _showChildPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: 12.h, bottom: 24.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 24.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text(
                  'Pilih Anak',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ..._children.map((child) {
                final isLast = child == _children.last;
                return Column(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _selectedChild = child;
                        });
                        context.pop();
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 16.h,
                        ),
                        child: Text(
                          child.name,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    if (!isLast)
                      const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0),
                        indent: 20,
                      ),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessDialog() async {
    bool isDialogClosed = false;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 40.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A735).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00A735),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 48.sp,
                          weight: 700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                  Text(
                    'Catatan Berhasil Disimpan 🎉',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00A735),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Hasil konsultasi telah tersimpan dan akan\nmenjadi acuan rekomendasi menu anak',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                  reverseCurve: Curves.easeInCubic,
                ),
              ),
          child: child,
        );
      },
    ).then((_) {
      isDialogClosed = true;
      if (mounted) {
        context.pop();
      }
    });

    await Future.delayed(const Duration(milliseconds: 2500));
    if (mounted && !isDialogClosed) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddEditMedicalNoteCubit, AddEditMedicalNoteState>(
      listener: (context, state) {
        if (state is AddEditMedicalNoteError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AddEditMedicalNoteSuccess) {
          _showSuccessDialog();
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: const Color(0xFFF9FAFB),
              appBar: const HeaderBasic(
                backgroundColor: Colors.white,
                title: 'Tambah Catatan',
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Pilih Anak
                            _buildSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(
                                    'Pilih Anak',
                                    isRequired: true,
                                  ),
                                  SizedBox(height: 12.h),
                                  InkWell(
                                    onTap: _showChildPicker,
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 14.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          8.r,
                                        ),
                                        border: Border.all(
                                          color: const Color(0xFFE0E0E0),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            _selectedChild?.name ??
                                                'Pilih Anak',
                                            style: TextStyle(
                                              fontFamily: 'PlusJakartaSans',
                                              color: _selectedChild == null
                                                  ? Colors.grey
                                                  : Colors.black87,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            color: Colors.grey,
                                            size: 20.sp,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Pilih profil anak untuk lanjut mengisi',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Identitas Dokter
                            _buildSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Identitas Dokter',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildSectionTitle(
                                    'Nama Dokter',
                                    isRequired: true,
                                    size: 12,
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildTextField(
                                    _doctorNameCtrl,
                                    'Contoh: dr. Sarah Wijaya',
                                  ),
                                  SizedBox(height: 16.h),
                                  _buildSectionTitle(
                                    'Tempat Praktik',
                                    isRequired: false,
                                    size: 12,
                                  ),
                                  SizedBox(height: 8.h),
                                  _buildTextField(
                                    _clinicNameCtrl,
                                    'Contoh: RSIA Hermina',
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Rekomendasi Medis
                            _buildSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(
                                    'Rekomendasi Medis',
                                    isRequired: true,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Tuliskan saran pola makan dari dokter',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  _buildTextField(
                                    _recommendationCtrl,
                                    'Contoh: Berikan makanan bertekstur lembut...',
                                    maxLines: 4,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Target Gizi Harian
                            _buildSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Target Gizi Harian',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Isi jika dokter menyebutkan angkanya',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),
                                  GridView.count(
                                    crossAxisCount: 2,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.9,
                                    children: [
                                      _buildNutritionStepper(
                                        title: 'Kalori',
                                        unit: 'kkal/hari',
                                        icon: Icons.local_fire_department,
                                        color: Colors.red,
                                        value: _calories,
                                        onDecrement: () => setState(
                                          () => _calories = _calories > 0
                                              ? _calories - 10.0
                                              : 0.0,
                                        ),
                                        onIncrement: () =>
                                            setState(() => _calories += 10.0),
                                      ),
                                      _buildNutritionStepper(
                                        title: 'Protein',
                                        unit: 'g/hari',
                                        icon: Icons.egg_alt,
                                        color: Colors.orange,
                                        value: _protein,
                                        onDecrement: () => setState(
                                          () => _protein = _protein > 0
                                              ? _protein - 1
                                              : 0,
                                        ),
                                        onIncrement: () =>
                                            setState(() => _protein += 1),
                                      ),
                                      _buildNutritionStepper(
                                        title: 'Lemak',
                                        unit: 'g/hari',
                                        icon: Icons.water_drop,
                                        color: Colors.green,
                                        value: _fat,
                                        onDecrement: () => setState(
                                          () => _fat = _fat > 0 ? _fat - 1 : 0,
                                        ),
                                        onIncrement: () =>
                                            setState(() => _fat += 1),
                                      ),
                                      _buildNutritionStepper(
                                        title: 'Karbohidrat',
                                        unit: 'g/hari',
                                        icon: Icons.grass,
                                        color: Colors.blue,
                                        value: _carbs,
                                        onDecrement: () => setState(
                                          () => _carbs = _carbs > 0
                                              ? _carbs - 1
                                              : 0,
                                        ),
                                        onIncrement: () =>
                                            setState(() => _carbs += 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Pantangan & Alergen
                            _buildSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Pantangan & Alergen',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  // Pantangan
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Pantangan,',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                color: Colors.red,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 4.w),
                                            ),
                                            TextSpan(
                                              text: 'hindari makanan ini',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                color: Colors.grey,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  if (_pantanganList.isNotEmpty) ...[
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _pantanganList
                                          .map(
                                            (e) => Chip(
                                              label: Text(
                                                e,
                                                style: TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
                                                  color: Colors.red,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.red.shade50,
                                              deleteIcon: Icon(
                                                Icons.close,
                                                size: 16.sp,
                                                color: Colors.red,
                                              ),
                                              onDeleted: () {
                                                setState(() {
                                                  _pantanganList.remove(e);
                                                });
                                              },
                                              side: BorderSide(
                                                color: Colors.red.shade100,
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    SizedBox(height: 10.h),
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          _pantanganCtrl,
                                          'Contoh: Makanan pedas',
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      InkWell(
                                        onTap: _addPantangan,
                                        child: Container(
                                          width: 48.w,
                                          height: 48.w,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.grey,
                                            size: 24.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'Ketik lalu tekan + untuk menambah',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(height: 16.h),

                                  // Alergen
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.info,
                                        color: Colors.orange,
                                        size: 16.sp,
                                      ),
                                      SizedBox(width: 6.w),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Alergen,',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                color: Colors.orange,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: SizedBox(width: 4.w),
                                            ),
                                            TextSpan(
                                              text:
                                                  'perhatikan reaksi tubuh anak',
                                              style: TextStyle(
                                                fontFamily: 'PlusJakartaSans',
                                                color: Colors.grey,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.h),
                                  if (_alergenList.isNotEmpty) ...[
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _alergenList
                                          .map(
                                            (e) => Chip(
                                              label: Text(
                                                e,
                                                style: TextStyle(
                                                  fontFamily: 'PlusJakartaSans',
                                                  color: Colors.orange,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              backgroundColor:
                                                  Colors.orange.shade50,
                                              deleteIcon: Icon(
                                                Icons.close,
                                                size: 16.sp,
                                                color: Colors.orange,
                                              ),
                                              onDeleted: () {
                                                setState(() {
                                                  _alergenList.remove(e);
                                                });
                                              },
                                              side: BorderSide(
                                                color: Colors.orange.shade100,
                                              ),
                                              padding: EdgeInsets.zero,
                                            ),
                                          )
                                          .toList(),
                                    ),
                                    SizedBox(height: 8.h),
                                  ],
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTextField(
                                          _alergenCtrl,
                                          'Contoh: Kacang tanah',
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      InkWell(
                                        onTap: _addAlergen,
                                        child: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              8.r,
                                            ),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.grey,
                                            size: 24.sp,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Ketik lalu tekan + untuk menambah',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.h),

                            // Waktu Berlaku
                            _buildSectionCard(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildSectionTitle(
                                    'Waktu Berlaku',
                                    isRequired: true,
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Catatan ini berlaku hingga',
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  CustomDatePickerField(
                                    initialDate: _validDate,
                                    hint: 'dd/mm/yyyy',
                                    onDateSelected: (date) {
                                      setState(() {
                                        _validDate = date;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                      decoration: const BoxDecoration(color: Colors.white),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: state is AddEditMedicalNoteLoading
                              ? null
                              : () {
                                  if (_selectedChild == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'field Pilih Anak wajib diisi',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  if (_doctorNameCtrl.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'field Nama Dokter wajib diisi',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  if (_recommendationCtrl.text.trim().isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'field Rekomendasi Medis wajib diisi',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }
                                  if (_validDate == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'field Waktu Berlaku wajib diisi',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    return;
                                  }

                                  final payload = MedicalNoteRequestModel(
                                    childId: widget.noteToEdit == null
                                        ? _selectedChild!.id
                                        : null,
                                    doctorName: _doctorNameCtrl.text.trim(),
                                    facilityName:
                                        _clinicNameCtrl.text.trim().isNotEmpty
                                        ? _clinicNameCtrl.text.trim()
                                        : null,
                                    recommendation: _recommendationCtrl.text
                                        .trim(),
                                    dailyNutritionTargets: [
                                      {
                                        'nutrient': 'calorie',
                                        'quantity': _calories,
                                      },
                                      {
                                        'nutrient': 'protein',
                                        'quantity': _protein,
                                      },
                                      {'nutrient': 'fat', 'quantity': _fat},
                                      {
                                        'nutrient': 'carbohydrate',
                                        'quantity': _carbs,
                                      },
                                    ],
                                    prohibitions: _pantanganList,
                                    allergies: _alergenList,
                                    validUntil: DateFormat(
                                      'dd-MM-yyyy',
                                    ).format(_validDate!),
                                  );

                                  if (widget.noteToEdit != null) {
                                    context
                                        .read<AddEditMedicalNoteCubit>()
                                        .editMedicalNote(
                                          widget.noteToEdit!.id,
                                          payload,
                                        );
                                  } else {
                                    context
                                        .read<AddEditMedicalNoteCubit>()
                                        .addMedicalNote(payload);
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00A735),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                            elevation: 0,
                          ),
                          child: state is AddEditMedicalNoteLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00A735),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  "Simpan Catatan",
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (state is AddEditMedicalNoteLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.1),
                  child: const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00A735)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(
    String title, {
    bool isRequired = false,
    double size = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: size,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (isRequired)
          Text(
            'Wajib',
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              color: Colors.red,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }

  Widget _buildTextField(
    TextEditingController? ctrl,
    String hint, {
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      style: const TextStyle(
        fontFamily: 'PlusJakartaSans',
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          fontFamily: 'PlusJakartaSans',
          color: (readOnly && ctrl == null && hint != 'dd/mm/yyyy')
              ? Colors.black87
              : Colors.grey,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Color(0xFF00A735)),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildNutritionStepper({
    required String title,
    required String unit,
    required IconData icon,
    required Color color,
    required num value,
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.sp,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: onDecrement,
                  child: Padding(
                    padding: EdgeInsets.all(4.0.w),
                    child: Icon(
                      Icons.remove,
                      size: 20.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                Text(
                  value is double ? value.toMacroFormat() : value.toString(),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                InkWell(
                  onTap: onIncrement,
                  child: Container(
                    padding: EdgeInsets.all(4.0.w),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.horizontal(
                        right: Radius.circular(8.r),
                      ),
                    ),
                    child: Icon(Icons.add, size: 20.sp, color: color),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            unit,
            style: TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 12.sp,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
