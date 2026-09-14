import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'dart:io';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_cubit.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_state.dart';
import 'package:nusagizi/features/caregiver/profile/data/models/update_caregiver_profile_request_model.dart';
import 'package:nusagizi/features/caregiver/profile/domain/entities/caregiver_profile_entity.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_cubit.dart';
import 'package:nusagizi/features/caregiver/profile/presentation/cubit/caregiver_profile_state.dart';

class CaregiverEditProfilePage extends StatefulWidget {
  final CaregiverProfileEntity initialProfile;

  const CaregiverEditProfilePage({super.key, required this.initialProfile});

  @override
  State<CaregiverEditProfilePage> createState() =>
      _CaregiverEditProfilePageState();
}

class _CaregiverEditProfilePageState extends State<CaregiverEditProfilePage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String _selectedGender = 'male';
  File? _pickedFile;

  Future<void> _pickImage() async {
    final xfile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (xfile != null) {
      setState(() => _pickedFile = File(xfile.path));
    }
  }

  @override
  void initState() {
    super.initState();
    // Pre-fill form dari data yang sudah di-load di ProfileCaregiverPage
    // Tidak perlu API call ulang
    _fullNameController.text = widget.initialProfile.fullName;
    _emailController.text = widget.initialProfile.email;
    _phoneController.text = widget.initialProfile.phoneNumber ?? '';
    _selectedGender = widget.initialProfile.gender ?? 'male';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile(BuildContext ctx) async {
    String? objectKey;
    if (_pickedFile != null) {
      final uploadCubit = ctx.read<ImageUploadCubit>();
      await uploadCubit.upload(
        file: _pickedFile!,
        category: 'profile',
        ownerId: widget.initialProfile.id,
      );
      if (!ctx.mounted) return;
      final st = uploadCubit.state;
      if (st is ImageUploadError) return;
      if (st is ImageUploadSuccess) objectKey = st.objectKey;
    }

    final request = UpdateCaregiverProfileRequestModel(
      fullName: _fullNameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      gender: _selectedGender,
      photoUrl: objectKey,
    );
    if (mounted) {
      ctx.read<CaregiverProfileCubit>().updateProfile(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ImageUploadCubit>(
      create: (_) => sl<ImageUploadCubit>(),
      child: BlocListener<ImageUploadCubit, ImageUploadState>(
        listener: (context, state) {
          if (state is ImageUploadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: const HeaderBasic(
            title: 'Ubah Profil Anda',
            backgroundColor: Colors.white,
          ),
          body: BlocConsumer<CaregiverProfileCubit, CaregiverProfileState>(
            listener: (context, state) {
              if (state is CaregiverProfileUpdateSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Profil berhasil diperbarui'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Reload agar data terbaru tersedia di halaman profil & edit
                context.read<CaregiverProfileCubit>().loadProfile();
              } else if (state is CaregiverProfileUpdateError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is CaregiverProfileLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00A735)),
                );
              }

              if (state is CaregiverProfileError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }

              return Column(
                children: [
                  BlocBuilder<ImageUploadCubit, ImageUploadState>(
                    builder: (context, state) {
                      if (state is ImageUploadInProgress) {
                        return LinearProgressIndicator(
                          value: state.progress,
                          color: const Color(0xFF00A735),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.all(20.0.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: _pickImage,
                                  child: Container(
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
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: _pickedFile != null
                                          ? FileImage(_pickedFile!)
                                                as ImageProvider
                                          : (widget.initialProfile.photoUrl !=
                                                    null
                                                ? NetworkImage(
                                                    widget
                                                        .initialProfile
                                                        .photoUrl!,
                                                  )
                                                : null),
                                      child:
                                          (_pickedFile == null &&
                                              widget.initialProfile.photoUrl ==
                                                  null)
                                          ? Icon(
                                              Icons.person,
                                              size: 40.w,
                                              color: Colors.grey,
                                            )
                                          : null,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12.h),
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
                          SizedBox(height: 32.h),
                          _buildLabel('Nama Lengkap'),
                          _buildTextField(
                            hint: 'Anggi Liana',
                            controller: _fullNameController,
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('Email'),
                          _buildTextField(
                            hint: 'anggip@gmail.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('Nomor HP'),
                          _buildTextField(
                            hint: '+62 8123 4567 899',
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20.h),
                          _buildLabel('Jenis Kelamin'),
                          RadioGroup<String>(
                            groupValue: _selectedGender,
                            onChanged: (String? val) {
                              if (val != null) {
                                setState(() {
                                  _selectedGender = val;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                _buildRadioItem('Laki-laki', 'male'),
                                SizedBox(width: 24.w),
                                _buildRadioItem('Perempuan', 'female'),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.all(20.0.w),
            child: SizedBox(
              width: double.infinity,
              height: 50.h,
              child: BlocBuilder<ImageUploadCubit, ImageUploadState>(
                builder: (context, imageState) {
                  return BlocBuilder<
                    CaregiverProfileCubit,
                    CaregiverProfileState
                  >(
                    builder: (context, state) {
                      final isLoading =
                          state is CaregiverProfileUpdateLoading ||
                          state is CaregiverProfileLoading ||
                          imageState is ImageUploadInProgress;

                      return ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                _saveProfile(context);
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00A735),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                          elevation: 0,
                        ),
                        child: isLoading
                            ? SizedBox(
                                height: 20.w,
                                width: 20.w,
                                child: const CircularProgressIndicator(
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
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: RichText(
        text: TextSpan(
          text: text,
          style: GoogleFonts.outfit(
            color: Colors.black87,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
          children: const [
            TextSpan(
              text: '*',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    TextEditingController? controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.outfit(color: Colors.grey),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF00A735)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: const BorderSide(color: Color(0xFF00A735), width: 2),
        ),
      ),
    );
  }

  Widget _buildRadioItem(String label, String value) {
    return Row(
      children: [
        Radio<String>(value: value, activeColor: const Color(0xFF00A735)),
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.black87, fontSize: 14.sp),
        ),
      ],
    );
  }
}
