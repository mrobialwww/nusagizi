import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/core/widgets/calendar/custom_date_picker_field.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/growth/data/models/add_growth_report_model.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/add_growth_report_cubit.dart';
import 'package:nusagizi/features/mother/growth/presentation/cubit/add_growth_report_state.dart';

class AddGrowthPage extends StatefulWidget {
  final String childId;
  const AddGrowthPage({super.key, required this.childId});

  @override
  State<AddGrowthPage> createState() => _AddGrowthPageState();
}

class _AddGrowthPageState extends State<AddGrowthPage> {
  DateTime? _selectedDate;
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _headCircumController = TextEditingController();

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    _headCircumController.dispose();
    super.dispose();
  }

  void _submitData(BuildContext context) {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tanggal pengukuran wajib diisi'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double? weight = double.tryParse(_weightController.text);
    final double? height = double.tryParse(_heightController.text);
    final double? headCircum = double.tryParse(_headCircumController.text);

    if (weight == null && height == null && headCircum == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Minimal isi satu data (Berat, Tinggi, atau Lingkar Kepala)',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    context.read<AddGrowthReportCubit>().submitReport(
      AddGrowthReportModel(
        childId: widget.childId,
        measuredAt: _selectedDate!,
        weightKg: weight,
        heightCm: height,
        headCircumferenceCm: headCircum,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AddGrowthReportCubit>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFFCFCFC),
            appBar: const HeaderBasic(
              backgroundColor: Color(0xFFFCFCFC),
              title: 'Tambah Data Pertumbuhan',
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(20.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInputLabel('Tanggal Pertumbuhan'),
                            CustomDatePickerField(
                              hint: 'Pilih Tanggal',
                              initialDate: _selectedDate,
                              onDateSelected: (date) {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                            ),
                            SizedBox(height: 16.h),
                            _buildInputLabel(
                              'Berat Badan (kg)',
                              isRequired: false,
                            ),
                            _buildTextField(
                              controller: _weightController,
                              hintText: '12.4',
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildInputLabel(
                              'Tinggi Badan (cm)',
                              isRequired: false,
                            ),
                            _buildTextField(
                              controller: _heightController,
                              hintText: '89',
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            _buildInputLabel(
                              'Lingkar Kepala (cm)',
                              isRequired: false,
                            ),
                            _buildTextField(
                              controller: _headCircumController,
                              hintText: '47',
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    BlocConsumer<AddGrowthReportCubit, AddGrowthReportState>(
                      listener: (context, state) {
                        if (state is AddGrowthReportSuccess) {
                          crudFlag = true;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Data berhasil disimpan!'),
                              backgroundColor: Color(0xFF00B14F),
                            ),
                          );
                          context.pop(true);
                        } else if (state is AddGrowthReportError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, state) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is AddGrowthReportLoading
                                ? null
                                : () => _submitData(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(
                                0xFF00B14F,
                              ), // Hijau Nuzagizi
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                              elevation: 0,
                            ),
                            child: state is AddGrowthReportLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00A735),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Simpan',
                                    style: GoogleFonts.outfit(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          children: [
            if (isRequired)
              TextSpan(
                text: ' *',
                style: GoogleFonts.outfit(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hintText,
    TextEditingController? controller,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.outfit(color: Colors.black54, fontSize: 13.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        style: GoogleFonts.outfit(color: Colors.black87, fontSize: 14.sp),
      ),
    );
  }
}
