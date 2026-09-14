import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/edit_child_profile_helpers.dart';
import 'package:nusagizi/core/widgets/calendar/custom_date_picker_field.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_state.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class AddEditChildProfileStep1 extends StatefulWidget {
  final bool isAddMode;

  const AddEditChildProfileStep1({super.key, required this.isAddMode});

  @override
  State<AddEditChildProfileStep1> createState() =>
      AddEditChildProfileStep1State();
}

class AddEditChildProfileStep1State extends State<AddEditChildProfileStep1> {
  File? pickedFile;

  Future<void> _pickImage() async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xfile != null) {
      if (mounted) setState(() => pickedFile = File(xfile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddEditProfileCubit>();
    // We only read the initial state once to avoid jumping cursor issues
    final initialState = cubit.state;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildStepHeader('Langkah 1', 'Identitas Dasar'),
          SizedBox(height: 24.h),
          Center(
            child: GestureDetector(
              onTap: _pickImage,
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00A735),
                        width: 2.w,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 50.r,
                      backgroundColor:
                          (pickedFile == null &&
                              ImageHelper.getSafeImageProvider(
                                    initialState.photoUrl,
                                  ) ==
                                  null)
                          ? ImageHelper.getAvatarColor(initialState.fullName)
                          : Colors.grey.shade200,
                      backgroundImage: pickedFile != null
                          ? FileImage(pickedFile!) as ImageProvider
                          : ImageHelper.getSafeImageProvider(
                              initialState.photoUrl,
                            ),
                      child:
                          (pickedFile == null &&
                              ImageHelper.getSafeImageProvider(
                                    initialState.photoUrl,
                                  ) ==
                                  null)
                          ? Text(
                              ImageHelper.getInitials(initialState.fullName),
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 40.sp,
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Unggah Foto',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF00A735),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32.h),
          buildLabel('Nama Lengkap', isRequired: true),
          _buildCustomTextField(
            initialValue: initialState.fullName,
            hintText: 'Contoh: Muhammad Razky',
            onChanged: (val) => cubit.updateStep1(
              fullName: val,
              birthDate: cubit.state.birthDate,
              gender: cubit.state.gender,
              weightKg: cubit.state.weightKg,
              heightCm: cubit.state.heightCm,
              headCircumferenceCm: cubit.state.headCircumferenceCm,
            ),
          ),
          SizedBox(height: 20.h),
          buildLabel('Tanggal Lahir', isRequired: true),
          BlocSelector<AddEditProfileCubit, AddEditProfileState, DateTime?>(
            selector: (state) => state.birthDate,
            builder: (context, birthDate) {
              return CustomDatePickerField(
                hint: 'Pilih Tanggal',
                initialDate: birthDate,
                onDateSelected: (date) {
                  cubit.updateStep1(
                    fullName: cubit.state.fullName,
                    birthDate: date,
                    gender: cubit.state.gender,
                    weightKg: cubit.state.weightKg,
                    heightCm: cubit.state.heightCm,
                    headCircumferenceCm: cubit.state.headCircumferenceCm,
                  );
                },
              );
            },
          ),
          SizedBox(height: 20.h),
          buildLabel('Jenis Kelamin', isRequired: true),
          BlocSelector<AddEditProfileCubit, AddEditProfileState, String>(
            selector: (state) => state.gender,
            builder: (context, gender) {
              return RadioGroup<String>(
                groupValue: gender == 'male'
                    ? 'Laki-laki'
                    : (gender == 'female' ? 'Perempuan' : ''),
                onChanged: (val) {
                  if (val != null) {
                    cubit.updateStep1(
                      fullName: cubit.state.fullName,
                      birthDate: cubit.state.birthDate,
                      gender: val == 'Laki-laki' ? 'male' : 'female',
                      weightKg: cubit.state.weightKg,
                      heightCm: cubit.state.heightCm,
                      headCircumferenceCm: cubit.state.headCircumferenceCm,
                    );
                  }
                },
                child: Row(
                  children: [
                    buildRadioItem('Laki-laki'),
                    SizedBox(width: 24.w),
                    buildRadioItem('Perempuan'),
                  ],
                ),
              );
            },
          ),
          if (widget.isAddMode) ...[
            SizedBox(height: 32.h),
            Text(
              'Data Pertumbuhan',
              style: GoogleFonts.outfit(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.h),
            buildLabel('Berat Badan (kg)', isRequired: true),
            _buildCustomTextField(
              initialValue: initialState.weightKg?.toString() ?? '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              hintText: 'Masukkan Berat Badan (kg)',
              onChanged: (val) => cubit.updateStep1(
                fullName: cubit.state.fullName,
                birthDate: cubit.state.birthDate,
                gender: cubit.state.gender,
                weightKg: double.tryParse(val),
                heightCm: cubit.state.heightCm,
                headCircumferenceCm: cubit.state.headCircumferenceCm,
              ),
            ),
            SizedBox(height: 20.h),
            buildLabel('Tinggi Badan (cm)', isRequired: true),
            _buildCustomTextField(
              initialValue: initialState.heightCm?.toString() ?? '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              hintText: 'Masukkan Tinggi Badan (cm)',
              onChanged: (val) => cubit.updateStep1(
                fullName: cubit.state.fullName,
                birthDate: cubit.state.birthDate,
                gender: cubit.state.gender,
                weightKg: cubit.state.weightKg,
                heightCm: double.tryParse(val),
                headCircumferenceCm: cubit.state.headCircumferenceCm,
              ),
            ),
            SizedBox(height: 20.h),
            buildLabel('Lingkar Kepala (cm)', isRequired: true),
            _buildCustomTextField(
              initialValue: initialState.headCircumferenceCm?.toString() ?? '',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              hintText: 'Masukkan Lingkar Kepala (cm)',
              onChanged: (val) => cubit.updateStep1(
                fullName: cubit.state.fullName,
                birthDate: cubit.state.birthDate,
                gender: cubit.state.gender,
                weightKg: cubit.state.weightKg,
                heightCm: cubit.state.heightCm,
                headCircumferenceCm: double.tryParse(val),
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required String initialValue,
    required String hintText,
    required ValueChanged<String> onChanged,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      style: GoogleFonts.outfit(fontSize: 13.sp, color: Colors.black87),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: GoogleFonts.outfit(color: Colors.grey, fontSize: 13.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF00A735)),
        ),
      ),
    );
  }
}
