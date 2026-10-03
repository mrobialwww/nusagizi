import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/mother/profile/domain/entities/child_profile_entity.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/child_profile_form_cubit.dart';
import 'package:nusagizi/features/mother/profile/presentation/cubit/add_edit_profile_state.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_cubit.dart';
import 'package:nusagizi/core/services/image_upload/presentation/cubit/image_upload_state.dart';
import 'package:nusagizi/features/mother/profile/data/models/child_profile_request_model.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/add_edit_child_profile_step1.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/add_edit_child_profile_step2.dart';
import 'package:nusagizi/features/mother/profile/presentation/widgets/add_edit_child_profile_step3.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

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
                _showSuccessDialog(context, widget.childData != null);
              } else if (state is ChildProfileFormDeleteSuccess) {
                crudFlag = true;

                sl<ChildrenCacheCubit>().remove(
                  widget.childData!.id,
                ); // hapus data anak dari hydrated bloc

                if (sl<ChildrenCacheCubit>().state.isEmpty) {
                  crudFlag = false;
                  context.pushReplacementNamed(AppRoutes.editChildProfile.name);
                } else {
                  context.pop();
                }
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
                  context.pop(result);
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
                            context.pop();
                          }
                        },
                  actions: [
                    if (widget.childData != null)
                      TextButton(
                        onPressed: () => _showDeleteConfirmation(context),
                        child: Text(
                          'Hapus',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
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
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w500,
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
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          'Data profil anak akan dihapus. Tindakan ini tidak dapat dibatalkan.',
          style: TextStyle(fontFamily: 'PlusJakartaSans'),
        ),
        actions: [
          TextButton(
            onPressed: () => ctx.pop(),
            child: Text(
              'Batal',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              ctx.pop();
              context.read<ChildProfileFormCubit>().deleteChildProfile(
                widget.childData!.id,
              );
            },
            child: Text(
              'Hapus',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
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

  void _showSuccessDialog(BuildContext context, bool isEdit) async {
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
                    isEdit
                        ? 'Profile Berhasil Diperbarui 🎉'
                        : 'Profile Berhasil Dibuat 🎉',
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
                    isEdit
                        ? 'Perubahan data anak telah berhasil disimpan'
                        : 'Semua siap! Yuk, mulai pantau pertumbuhan,\nperkembangan, dan kebutuhan si kecil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
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
      if (context.mounted) {
        if (!widget.fromHome) {
          context.pop();
        } else {
          motherNavTabNotifier.value = 0;
          context.goNamed(AppRoutes.homeMother.name);
        }
      }
    });

    await Future.delayed(const Duration(milliseconds: 2500));
    if (context.mounted && !isDialogClosed) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
