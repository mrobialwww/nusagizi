import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/create_caregiver_child_photo_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/create_caregiver_child_photo_state.dart';

class CaregiverCameraPage extends StatefulWidget {
  final String childId;
  const CaregiverCameraPage({super.key, required this.childId});

  @override
  State<CaregiverCameraPage> createState() => _CaregiverCameraPageState();
}

class _CaregiverCameraPageState extends State<CaregiverCameraPage> {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  bool _isCameraInitialized = false;
  File? _capturedImage;
  FlashMode _flashMode = FlashMode.off;

  final CreateCaregiverChildPhotoCubit _uploadCubit =
      sl<CreateCaregiverChildPhotoCubit>();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isNotEmpty) {
        _selectedCameraIndex = _cameras.indexWhere(
          (c) => c.lensDirection == CameraLensDirection.back,
        );
        if (_selectedCameraIndex == -1) _selectedCameraIndex = 0;
        await _setupCameraController();
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  Future<void> _setupCameraController() async {
    if (_cameras.isEmpty) return;

    final camera = _cameras[_selectedCameraIndex];
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    try {
      await _cameraController!.initialize();
      await _cameraController!.setFlashMode(_flashMode);
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error setting up camera: $e');
    }
  }

  @override
  void dispose() {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      _cameraController?.dispose();
    }
    _uploadCubit.close();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_cameraController != null && _cameraController!.value.isInitialized) {
      try {
        final image = await _cameraController!.takePicture();
        setState(() {
          _capturedImage = File(image.path);
        });
      } catch (e) {
        debugPrint('Error capturing image: $e');
      }
    }
  }

  void _switchCamera() async {
    if (_cameras.isEmpty) return;

    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    _isCameraInitialized = false;
    setState(() {});

    if (_cameraController != null) {
      await _cameraController!.dispose();
    }
    await _setupCameraController();
  }

  void _toggleFlash() async {
    if (_cameraController == null) return;
    try {
      setState(() {
        _flashMode = _flashMode == FlashMode.off
            ? FlashMode.torch
            : FlashMode.off;
      });
      if (_cameraController!.value.isInitialized) {
        await _cameraController!.setFlashMode(_flashMode);
      }
    } catch (e) {
      debugPrint('Error toggling flash: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _uploadCubit,
      child:
          BlocListener<
            CreateCaregiverChildPhotoCubit,
            CreateCaregiverChildPhotoState
          >(
            listener: (context, state) {
              if (state is CreateCaregiverChildPhotoSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foto berhasil dikirim!')),
                );
                context.pop();
              } else if (state is CreateCaregiverChildPhotoFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            child: Scaffold(
              backgroundColor: const Color(0xFF1E1E1E),
              appBar: AppBar(
                toolbarHeight: 0,
                backgroundColor: Colors.transparent,
                elevation: 0,
                systemOverlayStyle: SystemUiOverlayStyle.light,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    // Top Bar
                    if (_capturedImage != null)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0.h),
                        child: SizedBox(
                          height: 48.h,
                          child: Center(
                            child: Text(
                              'Bagikan',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.0.w,
                          vertical: 16.0.h,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Teks Ambil Foto (tengah pas)
                            Text(
                              'Ambil Foto',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            // Back Button (kiri)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: GestureDetector(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.all(12.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 50.h),
                    // Camera Preview Viewfinder
                    _buildCameraPreview(context),
                    SizedBox(height: 75.h),
                    // Camera Controls
                    _buildCameraControls(context),
                    SizedBox(height: 150.h),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  Widget _buildCameraPreview(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(36.r),
              child: SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: _capturedImage != null
                    ? Image.file(
                        _capturedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      )
                    : (!_isCameraInitialized || _cameraController == null)
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : OverflowBox(
                        alignment: Alignment.center,
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width:
                                _cameraController!.value.previewSize?.height ??
                                1,
                            height:
                                _cameraController!.value.previewSize?.width ??
                                1,
                            child: CameraPreview(_cameraController!),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraControls(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (_capturedImage != null)
            IconButton(
              onPressed: () {
                setState(() => _capturedImage = null);
              }, // Close button
              icon: Icon(Icons.close, color: Colors.white, size: 36.sp),
            )
          else
            IconButton(
              onPressed: _toggleFlash,
              icon: Icon(
                _flashMode == FlashMode.torch
                    ? Icons.flash_on
                    : Icons.flash_off,
                color: Colors.white,
                size: 36.sp,
              ),
            ),

          if (_capturedImage != null)
            BlocBuilder<
              CreateCaregiverChildPhotoCubit,
              CreateCaregiverChildPhotoState
            >(
              builder: (context, state) {
                if (state is CreateCaregiverChildPhotoLoading) {
                  return Container(
                    width: 85.w,
                    height: 85.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D3D3D),
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(24.w),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    _uploadCubit.submitPhoto(
                      imageFile: _capturedImage!,
                      childId: widget.childId,
                    );
                  },
                  child: Container(
                    width: 85.w,
                    height: 85.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4CAF50),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 36.sp),
                  ),
                );
              },
            )
          else
            GestureDetector(
              onTap: _takePhoto,
              child: Container(
                width: 85.w,
                height: 85.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4.w),
                ),
                padding: EdgeInsets.all(6.w),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),

          if (_capturedImage != null)
            IconButton(
              onPressed: () {}, // Dummy download action
              icon: Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 36.sp,
              ),
            )
          else
            IconButton(
              onPressed: _switchCamera,
              icon: Icon(Icons.sync, color: Colors.white, size: 36.sp),
            ),
        ],
      ),
    );
  }
}
