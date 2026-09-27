import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/core/widgets/headers/header_basic.dart';
import 'package:nusagizi/features/caregiver/home/domain/entities/child_preview_entity.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_qr_cubit.dart';
import 'package:nusagizi/features/caregiver/home/presentation/cubit/caregiver_qr_state.dart';
import 'package:nusagizi/features/caregiver/home/presentation/widgets/checkin_access_bottom_sheet.dart';

class CaregiverQRPage extends StatefulWidget {
  const CaregiverQRPage({super.key});

  @override
  State<CaregiverQRPage> createState() => _CaregiverQRPageState();
}

class _CaregiverQRPageState extends State<CaregiverQRPage> {
  late final MobileScannerController _controller;
  bool _isScanning = true;
  // Guard: prevents reprocessing the same QR value after camera restarts.
  // Without this, stop() + start() resets the scanner's duplicate-detection
  // cache, causing the same QR to trigger an infinite loop of API calls.
  String? _lastScannedValue;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      autoStart: true,
      detectionSpeed: DetectionSpeed.noDuplicates,
      facing: CameraFacing.back,
      formats: const [BarcodeFormat.qrCode],
      torchEnabled: false,
      returnImage: false,
      autoZoom: true,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Handle QR code detection
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (!_isScanning) return;

    final rawValue = capture.barcodes.firstOrNull?.rawValue;
    if (rawValue == null || rawValue == _lastScannedValue) return;

    String token;
    String childId;

    try {
      final Map<String, dynamic> data = jsonDecode(rawValue);
      token = data['token'] as String;
      childId = data['childId'] as String;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'QR Code tidak valid atau bukan QR Nusagizi.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    _lastScannedValue = rawValue;
    setState(() => _isScanning = false);
    await _controller.stop();

    if (mounted) {
      context.read<CaregiverQRCubit>().fetchChildPreview(token, childId);
    }
  }

  // Handle image picking from gallery
  Future<void> _pickFromGallery() async {
    if (!_isScanning) return;

    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final result = await _controller.analyzeImage(picked.path);
    final rawValue = result?.barcodes.firstOrNull?.rawValue;

    if (rawValue == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak ada QR yang terdeteksi di gambar ini.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    String token;
    String childId;

    try {
      final Map<String, dynamic> data = jsonDecode(rawValue);
      token = data['token'] as String;
      childId = data['childId'] as String;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'QR Code tidak valid atau bukan QR Nusagizi.',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    _lastScannedValue = rawValue;
    setState(() => _isScanning = false);
    await _controller.stop();

    if (mounted) {
      context.read<CaregiverQRCubit>().fetchChildPreview(token, childId);
    }
  }

  /// Restarts the camera scanning process.
  /// This is crucial because scanning is immediately paused upon detecting a QR code.
  /// If the user cancels the check-in or if an API error occurs (e.g., 404 Not Found),
  /// this method ensures the camera unfreezes so they can try scanning again.
  Future<void> _resumeScanning() async {
    // Clear the last scanned value so the same QR can be scanned again on an explicit user-initiated retry.
    _lastScannedValue = null;
    setState(() => _isScanning = true);

    // Always stop before starting to avoid the "MobileScannerController is already running" error.
    try {
      await _controller.stop();
    } catch (_) {}
    try {
      await _controller.start();
    } catch (_) {}
  }

  // Returns `true` for success, `false` for conflict, or `null` on error.
  Future<bool?> _submitCheckin(String token) async {
    final cubit = context.read<CaregiverQRCubit>();
    cubit.submitCheckin(token);

    final state = await cubit.stream.firstWhere(
      (s) =>
          s is CaregiverQRCheckinSuccess ||
          (s is CaregiverQRError && s.isCheckinError),
    );

    if (state is CaregiverQRCheckinSuccess) {
      return state.isNewEngagement;
    } else if (state is CaregiverQRError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.message,
              style: const TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontWeight: FontWeight.w500,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
    return null;
  }

  // Show bottom sheet for checkin confirmation or result
  Future<void> _showCheckinSheet(ChildPreviewEntity data, String childId) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckinAccessBottomSheet(
        data: data,
        onAccept: () => _submitCheckin(childId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CaregiverQRCubit, CaregiverQRState>(
      listener: (context, state) async {
        if (state is CaregiverQRPreviewSuccess) {
          await _showCheckinSheet(state.data, state.token);
          await _resumeScanning();
        } else if (state is CaregiverQRError && !state.isCheckinError) {
          // Do NOT auto-resume here. Auto-resuming causes an infinite loop:
          // camera restarts → same QR still in frame → onDetect fires again
          // → same API error → resume → repeat.
          // The user must tap "Scan Ulang" to explicitly retry.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontWeight: FontWeight.w500,
                ),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is CaregiverQRLoading;
        return PopScope(
          canPop: !isLoading,
          child: Stack(
            children: [
              Scaffold(
                extendBodyBehindAppBar: true,
                appBar: const HeaderBasic(
                  backgroundColor: Colors.transparent,
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                  title: 'Pindai QR',
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
                body: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.asset(
                        AppImages.qrBackground,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned.fill(
                      child: Container(color: const Color(0x99000000)),
                    ),
                    SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              'Pindai QR Code yang dibagikan oleh orang tua untuk membantu menjalankan rutinitas harian anak',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontWeight: FontWeight.w500,
                                fontSize: 13.sp,
                                color: const Color(0xE6FFFFFF),
                              ),
                            ),
                          ),
                          const Spacer(flex: 1),
                          _buildScannerBox(),
                          SizedBox(height: 40.h),
                          if (_isScanning)
                            _buildBottomButtons()
                          else if (state is CaregiverQRError &&
                              !state.isCheckinError)
                            _buildRetryButton(),
                          const Spacer(flex: 1),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black54,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: _pickFromGallery,
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x33FFFFFF),
            ),
            child: Icon(Icons.image, color: Colors.white, size: 28.sp),
          ),
        ),
        SizedBox(width: 48.w),
        ValueListenableBuilder<MobileScannerState>(
          valueListenable: _controller,
          builder: (context, state, child) {
            if (state.torchState == TorchState.unavailable) {
              return SizedBox(width: 64.w);
            }
            return GestureDetector(
              onTap: _controller.toggleTorch,
              child: Container(
                width: 64.w,
                height: 64.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0x33FFFFFF),
                ),
                child: Icon(
                  state.torchState == TorchState.on
                      ? Icons.flash_on
                      : Icons.flash_off,
                  color: Colors.white,
                  size: 28.sp,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRetryButton() {
    return GestureDetector(
      onTap: _resumeScanning,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: const Color(0x33FFFFFF),
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, color: Colors.white, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'Scan Ulang',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerBox() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Camera View
        Container(
          width: 250.w,
          height: 250.w,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.r)),
          clipBehavior: Clip.hardEdge,
          child: MobileScanner(controller: _controller, onDetect: _onDetect),
        ),
        // Corner Borders
        CustomPaint(size: Size(280.w, 280.w), painter: ScannerBorderPainter()),
      ],
    );
  }
}

class ScannerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const len = 32.0;
    const r = 24.0;

    void drawCorner(double dx, double dy, double sx, double sy) {
      canvas.drawPath(
        Path()
          ..moveTo(dx, dy + sy * len)
          ..lineTo(dx, dy + sy * r)
          ..arcToPoint(
            Offset(dx + sx * r, dy),
            radius: const Radius.circular(r),
            clockwise: sx == sy,
          )
          ..lineTo(dx + sx * len, dy),
        paint,
      );
    }

    drawCorner(0, 0, 1, 1); // Top Left
    drawCorner(size.width, 0, -1, 1); // Top Right
    drawCorner(size.width, size.height, -1, -1); // Bottom Right
    drawCorner(0, size.height, 1, -1); // Bottom Left
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
