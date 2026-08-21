import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_form_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_state.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/mother_home_cubit.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_cubit.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_state.dart';

import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/add_edit_child_profile_step1.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/add_edit_child_profile_step2.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/add_edit_child_profile_step3.dart';

class AddOrEditChildProfile extends StatefulWidget {
  final ChildProfileEntity? childData;
  final bool fromHome;

  const AddOrEditChildProfile({
    super.key,
    this.childData,
    this.fromHome = false,
  });

  @override
  State<AddOrEditChildProfile> createState() => _AddOrEditChildProfileState();
}

class _AddOrEditChildProfileState extends State<AddOrEditChildProfile> {
  int _currentStep = 0;

  final _step1Key = GlobalKey<AddEditChildProfileStep1State>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ImageUploadCubit>()),
        BlocProvider(create: (_) => sl<ChildProfileFormCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ImageUploadCubit, ImageUploadState>(
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
          ),
          BlocListener<ChildProfileFormCubit, ChildProfileFormState>(
            listener: (context, state) {
              if (state is ChildProfileFormSuccess) {
                crudFlag = true;
                sl<MotherHomeCubit>().getChildrenSummary();
                _showSuccessDialog(context, widget.childData != null);
              } else if (state is ChildProfileFormDeleteSuccess) {
                crudFlag = true;
                sl<MotherHomeCubit>().getChildrenSummary();
                Navigator.pop(context);
                Navigator.pop(context);
              } else if (state is ChildProfileFormFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        ],
        child: BlocBuilder<ChildProfileFormCubit, ChildProfileFormState>(
          builder: (context, state) {
            return PopScope(
              canPop: false,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (_currentStep > 0) {
                  setState(() {
                    _currentStep--;
                  });
                } else if (!widget.fromHome) {
                  Navigator.pop(context, result);
                }
              },
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: HeaderBasic(
                  backgroundColor: Colors.white,
                  title: widget.childData == null
                      ? 'Tambah Profil Anak'
                      : 'Ubah Data Profil',
                  automaticallyImplyLeading:
                      !(widget.fromHome && _currentStep == 0),
                  onBackPressed: (widget.fromHome && _currentStep == 0)
                      ? null
                      : () {
                          if (_currentStep > 0) {
                            setState(() {
                              _currentStep--;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        },
                  actions: [
                    if (widget.childData != null)
                      TextButton(
                        onPressed: () => _showDeleteConfirmation(context),
                        child: Text(
                          'Hapus',
                          style: GoogleFonts.outfit(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
                body: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                      child: Row(
                        children: [
                          _buildStepIndicator(isActive: _currentStep >= 0),
                          SizedBox(width: 8.w),
                          _buildStepIndicator(isActive: _currentStep >= 1),
                          SizedBox(width: 8.w),
                          _buildStepIndicator(isActive: _currentStep >= 2),
                        ],
                      ),
                    ),
                    Expanded(
                      child:
                          BlocBuilder<AddEditProfileCubit, AddEditProfileState>(
                            builder: (context, profileState) {
                              if (profileState.isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF00A735),
                                  ),
                                );
                              }
                              return _buildCurrentStep();
                            },
                          ),
                    ),
                  ],
                ),
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.all(20.0.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: BlocBuilder<ImageUploadCubit, ImageUploadState>(
                      builder: (context, imageState) {
                        final isLoading =
                            state is ChildProfileFormLoading ||
                            imageState is ImageUploadInProgress;
                        return ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () => _onNextStep(context),
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
                                  _currentStep == 2
                                      ? 'Simpan Profil'
                                      : 'Selanjutnya',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15.sp,
                                  ),
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    return IndexedStack(
      index: _currentStep,
      children: [
        AddEditChildProfileStep1(
          key: _step1Key,
          isAddMode: widget.childData == null,
        ),
        const AddEditChildProfileStep2(),
        const AddEditChildProfileStep3(),
      ],
    );
  }

  bool _validateCurrentStep(BuildContext context) {
    if (_currentStep == 0) {
      final formState = context.read<AddEditProfileCubit>().state;
      if (formState.fullName.trim().isEmpty) {
        _showErrorSnackbar(context, "Nama lengkap harus diisi");
        return false;
      }
      if (formState.birthDate == null) {
        _showErrorSnackbar(context, "Tanggal lahir harus diisi");
        return false;
      }
      if (formState.gender.isEmpty) {
        _showErrorSnackbar(context, "Jenis kelamin harus dipilih");
        return false;
      }
      if (widget.childData == null) {
        if (formState.weightKg == null) {
          _showErrorSnackbar(context, "Berat badan saat ini harus diisi");
          return false;
        }
        if (formState.heightCm == null) {
          _showErrorSnackbar(context, "Tinggi badan saat ini harus diisi");
          return false;
        }
        if (formState.headCircumferenceCm == null) {
          _showErrorSnackbar(context, "Lingkar kepala saat ini harus diisi");
          return false;
        }
      }
    }
    return true;
  }

  void _showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Hapus Profil Anak?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Data profil anak akan dihapus. Tindakan ini tidak dapat dibatalkan.',
          style: GoogleFonts.outfit(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Batal', style: GoogleFonts.outfit(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ChildProfileFormCubit>().deleteChildProfile(
                widget.childData!.id,
              );
            },
            child: Text(
              'Hapus',
              style: GoogleFonts.outfit(
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onNextStep(BuildContext context) async {
    if (!_validateCurrentStep(context)) return;
    if (_currentStep < 2) {
      setState(() {
        _currentStep++;
      });
    } else {
      await _submitProfile(context);
    }
  }

  Future<void> _submitProfile(BuildContext context) async {
    final formState = context.read<AddEditProfileCubit>().state;
    String? objectKey;
    final pickedFile = _step1Key.currentState?.pickedFile;

    if (pickedFile != null) {
      final uploadCubit = context.read<ImageUploadCubit>();
      await uploadCubit.upload(
        file: pickedFile,
        category: 'child-profile',
        ownerId: widget.childData?.id,
      );
      if (!context.mounted) return;
      final st = uploadCubit.state;
      if (st is ImageUploadError) return;
      if (st is ImageUploadSuccess) objectKey = st.objectKey;
    }

    final request = ChildProfileRequestModel(
      fullName: formState.fullName,
      birthDate:
          "${formState.birthDate!.day.toString().padLeft(2, '0')}-${formState.birthDate!.month.toString().padLeft(2, '0')}-${formState.birthDate!.year}",
      gender: formState.gender,
      photoUrl: objectKey ?? formState.photoUrl,
      allergies: formState.allergies,
      chronicDiseases: formState.chronicDiseases,
      diets: formState.diets,
      favoriteFoods: formState.favoriteFoods,
      favoriteTextures: formState.favoriteTextures,
      notes: formState.notes,
    );

    if (widget.childData != null) {
      context.read<ChildProfileFormCubit>().updateProfile(
        widget.childData!.id,
        request,
      );
    } else {
      context.read<ChildProfileFormCubit>().submitProfile(
        request,
        weightKg: formState.weightKg,
        heightCm: formState.heightCm,
        headCircumferenceCm: formState.headCircumferenceCm,
      );
    }
  }

  Widget _buildStepIndicator({required bool isActive}) {
    return Expanded(
      child: Container(
        height: 6.h,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF00B14F) : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, bool isEdit) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: const Color(0xFF00A735),
                    size: 80.w,
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    isEdit ? 'Profil Diperbarui!' : 'Profil Dibuat!',
                    style: GoogleFonts.outfit(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    isEdit
                        ? 'Data profil anak berhasil diperbarui.'
                        : 'Profil anak berhasil ditambahkan.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(
                      fontSize: 14.sp,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Menutup dialog
                        if (!isEdit) {
                          context.goNamed(AppRoutes.homeMother.name);
                        } else {
                          Navigator.pop(context); // Kembali ke list
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
                      child: Text(
                        'Kembali',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
