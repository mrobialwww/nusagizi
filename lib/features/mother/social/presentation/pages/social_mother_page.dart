import 'dart:io';
import 'dart:async';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:nusagizi/core/config/assets/app_images.dart';
import 'package:nusagizi/features/mother/social/presentation/widgets/social_friends_bottom_sheet.dart';
import 'package:nusagizi/features/mother/social/presentation/widgets/gallery_bottom_sheet.dart';
import 'package:nusagizi/core/layout/mother_layout_scaffold.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/create_child_photo_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/create_child_photo_state.dart';
import 'package:nusagizi/core/utils/image_helper.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/retake_photo_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/retake_photo_state.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class SocialMotherPage extends StatefulWidget {
  final String? retakeUrl;
  const SocialMotherPage({super.key, this.retakeUrl});

  @override
  State<SocialMotherPage> createState() => _SocialMotherPageState();
}

class _SocialMotherPageState extends State<SocialMotherPage> {
  late final AppLifecycleListener _lifecycleListener;
  bool isPhotoTaken = false;
  String _visibilityMode = 'all';
  final List<String> _selectedContactIds = [];
  int _selectedChildIndex = 0;

  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.auto;
  XFile? _capturedImage;
  bool _isCameraInitialized = false;
  final TextEditingController _captionController = TextEditingController();

  /// Mengaktifkan kembali sensor kamera saat modal/halaman lain ditutup,
  /// karena plugin camera sering membeku saat kehilangan fokus.
  void _onModalClosed() {
    if (mounted) {
      if (!isPhotoTaken) {
        _setupCameraController();
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _lifecycleListener = AppLifecycleListener(
      onInactive: () {
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          try {
            _cameraController?.dispose();
          } catch (e) {
            debugPrint('Error disposing on inactive: $e');
          }
        }
      },
      onResume: () {
        if (_cameraController != null &&
            _cameraController!.value.isInitialized) {
          _setupCameraController();
        }
      },
    );
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

    if (mounted) {
      setState(() {
        _isCameraInitialized = false;
      });
    }

    if (_cameraController != null) {
      try {
        await _cameraController!.dispose();
      } catch (e) {
        debugPrint('Error disposing old camera controller in setup: $e');
      }
      _cameraController = null;
    }

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

  Future<XFile> _fixFrontCameraImage(XFile originalFile) async {
    final bytes = await originalFile.readAsBytes();
    final decoded = img.decodeImage(bytes);
    if (decoded == null) return originalFile;

    final flipped = img.flipHorizontal(decoded);
    // Tulis ulang byte yang sudah di-flip ke file ASLI
    File(
      originalFile.path,
    ).writeAsBytesSync(img.encodeJpg(flipped, quality: 92));

    return originalFile;
  }

  @override
  void dispose() {
    _lifecycleListener.dispose();
    if (_cameraController != null) {
      try {
        _cameraController!.dispose();
      } catch (e) {
        debugPrint('Error disposing camera controller: $e');
      }
    }
    _captionController.dispose();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hideMotherNavBarNotifier.value = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ContactsCubit>()..fetchContacts()),
        BlocProvider.value(value: sl<ChildrenCacheCubit>()),
        BlocProvider(create: (context) => sl<CreateChildPhotoCubit>()),
        BlocProvider(create: (context) => sl<RetakePhotoCubit>()),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<RetakePhotoCubit, RetakePhotoState>(
            listener: (context, state) async {
              if (state is RetakePhotoFailure) {
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
              } else if (state is RetakePhotoSuccess) {
                if (context.mounted) {
                  setState(() {
                    isPhotoTaken = false;
                    _capturedImage = null;
                    _captionController.clear();
                    hideMotherNavBarNotifier.value = false;
                  });
                  context.goNamed(AppRoutes.socialMother.name);
                }
              }
            },
          ),
          BlocListener<CreateChildPhotoCubit, CreateChildPhotoState>(
            listener: (context, state) {
              if (state is CreateChildPhotoSuccess) {
                setState(() {
                  isPhotoTaken = false;
                  _capturedImage = null;
                  _captionController.clear();
                  hideMotherNavBarNotifier.value = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Foto berhasil diunggah',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              } else if (state is CreateChildPhotoFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
        child: Builder(
          builder: (context) {
            return Scaffold(
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
                    _buildTopBar(context),
                    SizedBox(height: 20.h),
                    _buildCameraPreview(),
                    SizedBox(height: 40.h),
                    _buildCameraControls(),
                    SizedBox(height: 40.h),
                    _buildBottomAction(context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    if (isPhotoTaken) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0.h),
        child: SizedBox(
          height: 48.h,
          child: Center(
            child: Text(
              'Bagikan',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 16.0.h),
      child: Row(
        mainAxisAlignment: widget.retakeUrl != null
            ? MainAxisAlignment.end
            : MainAxisAlignment.spaceBetween,
        children: [
          // Calendar Button
          if (widget.retakeUrl == null)
            GestureDetector(
              onTap: () {
                String? activeChildId;
                final children = context.read<ChildrenCacheCubit>().state;
                if (children.isNotEmpty &&
                    _selectedChildIndex < children.length) {
                  activeChildId = children[_selectedChildIndex].id;
                }
                context
                    .pushNamed(
                      AppRoutes.photoMemories.name,
                      extra: activeChildId,
                    )
                    .then((_) => _onModalClosed());
              },
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ),

          // Friends Chip
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useRootNavigator: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const FractionallySizedBox(
                  heightFactor: 0.95,
                  child: SocialFriendsBottomSheet(),
                ),
              ).then((_) => _onModalClosed());
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.people, color: Colors.white, size: 20.sp),
                  SizedBox(width: 8.w),
                  BlocBuilder<ContactsCubit, ContactsState>(
                    builder: (context, state) {
                      String countStr = '0 Teman';
                      if (state is ContactsLoaded) {
                        countStr = '${state.contacts.length} Teman';
                      }
                      return Text(
                        countStr,
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: Colors.white,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Top Right Profile Selector
          _buildChildDropdown(context),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(36.r),
              child: _capturedImage != null
                  ? Image.file(
                      File(_capturedImage!.path),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : (!_isCameraInitialized || _cameraController == null)
                  ? Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black,
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    )
                  : SizedBox.expand(
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: SizedBox(
                          width:
                              _cameraController!.value.previewSize?.height ?? 1,
                          height:
                              _cameraController!.value.previewSize?.width ?? 1,
                          child: CameraPreview(_cameraController!),
                        ),
                      ),
                    ),
            ),
            if (isPhotoTaken)
              Positioned(
                bottom: 20.h,
                left: 20.w,
                right: 20.w,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 2.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: TextField(
                    controller: _captionController,
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Tambah pesan',
                      hintStyle: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.white70,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (isPhotoTaken)
            IconButton(
              onPressed: () {
                hideMotherNavBarNotifier.value = false;
                setState(() {
                  isPhotoTaken = false;
                  _capturedImage = null;
                });
              },
              icon: Icon(Icons.close, color: Colors.white, size: 36.sp),
            )
          else
            IconButton(
              onPressed: () async {
                if (_cameraController == null) return;
                setState(() {
                  if (_flashMode == FlashMode.auto) {
                    _flashMode = FlashMode.torch;
                  } else if (_flashMode == FlashMode.torch) {
                    _flashMode = FlashMode.off;
                  } else {
                    _flashMode = FlashMode.auto;
                  }
                });
                try {
                  await _cameraController!.setFlashMode(_flashMode);
                } catch (e) {
                  debugPrint('Error setting flash mode: $e');
                }
              },
              icon: Icon(
                _flashMode == FlashMode.off
                    ? Icons.flash_off
                    : _flashMode == FlashMode.torch
                    ? Icons.flash_on
                    : Icons.flash_auto,
                color: Colors.white,
                size: 36.sp,
              ),
            ),

          if (isPhotoTaken)
            BlocBuilder<CreateChildPhotoCubit, CreateChildPhotoState>(
              builder: (context, state) {
                if (state is CreateChildPhotoLoading) {
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
                      ),
                    ),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    String visibility = _visibilityMode;
                    List<String>? listVisibility =
                        _selectedContactIds.isNotEmpty
                        ? _selectedContactIds
                        : null;

                    if (visibility == 'selected_only' &&
                        listVisibility == null) {
                      visibility = 'private';
                    }

                    final children = context.read<ChildrenCacheCubit>().state;
                    final childId = children.isNotEmpty
                        ? children[_selectedChildIndex].id
                        : '';

                    if (widget.retakeUrl != null) {
                      String existingObjectKey = widget.retakeUrl!;
                      try {
                        final uri = Uri.parse(widget.retakeUrl!);
                        existingObjectKey = uri.path.startsWith('/')
                            ? uri.path.substring(1)
                            : uri.path;
                      } catch (_) {}

                      context.read<RetakePhotoCubit>().retake(
                        imageFile: File(_capturedImage!.path),
                        existingObjectKey: existingObjectKey,
                      );
                    } else {
                      context.read<CreateChildPhotoCubit>().submitPhoto(
                        imageFile: File(_capturedImage!.path),
                        childId: childId,
                        caption: _captionController.text.trim(),
                        visibility: visibility,
                        listVisibility: listVisibility,
                      );
                    }
                  },
                  child: Container(
                    width: 85.w,
                    height: 85.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D3D3D),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white, size: 36.sp),
                  ),
                );
              },
            )
          else
            GestureDetector(
              onTap: () async {
                if (_cameraController != null &&
                    _cameraController!.value.isInitialized) {
                  try {
                    final rawImage = await _cameraController!.takePicture();

                    // Perbaiki mirror untuk front camera di level pixel
                    final isFront =
                        _cameras.isNotEmpty &&
                        _cameras[_selectedCameraIndex].lensDirection ==
                            CameraLensDirection.front;

                    final finalImage = isFront
                        ? await _fixFrontCameraImage(rawImage)
                        : rawImage;

                    hideMotherNavBarNotifier.value = true;

                    setState(() {
                      _capturedImage = finalImage;
                      isPhotoTaken = true;
                    });
                  } catch (e) {
                    debugPrint('Error taking picture: $e');
                  }
                }
              },
              child: Container(
                width: 85.w,
                height: 85.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
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

          if (isPhotoTaken)
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.file_download_outlined,
                color: Colors.white,
                size: 36.sp,
              ),
            )
          else
            IconButton(
              onPressed: () async {
                if (_cameras.isEmpty) return;
                setState(() {
                  _isCameraInitialized = false;
                  _selectedCameraIndex =
                      (_selectedCameraIndex + 1) % _cameras.length;
                });
                await _setupCameraController();
              },
              icon: Icon(Icons.sync, color: Colors.white, size: 36.sp),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
    if (isPhotoTaken) {
      return SizedBox(
        height: 96.h,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.sizeOf(context).width / 2 - 24,
          ),
          children: [
            // Semua
            _buildOption(
              icon: Icons.people,
              label: 'Semua',
              isSelected: _visibilityMode == 'all',
              iconBackgroundColor: const Color(0xFF4A4A4A),
              onTap: () => setState(() {
                _visibilityMode = 'all';
                _selectedContactIds.clear();
              }),
            ),
            // Pribadi
            _buildOption(
              icon: Icons.lock,
              label: 'Pribadi',
              isSelected: _visibilityMode == 'private',
              iconBackgroundColor: const Color(0xFF4A4A4A),
              onTap: () => setState(() {
                _visibilityMode = 'private';
                _selectedContactIds.clear();
              }),
            ),
            // Friends List from API
            BlocBuilder<ContactsCubit, ContactsState>(
              builder: (context, state) {
                if (state is ContactsLoaded) {
                  return Row(
                    children: state.contacts.map((contact) {
                      final isSelected = _selectedContactIds.contains(
                        contact.contactId,
                      );

                      final imageProvider = ImageHelper.getSafeImageProvider(
                        contact.photoUrl,
                      );

                      return Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _visibilityMode = 'selected_only';
                              if (isSelected) {
                                _selectedContactIds.remove(contact.contactId);
                                if (_selectedContactIds.isEmpty) {
                                  _visibilityMode = 'private';
                                }
                              } else {
                                _selectedContactIds.add(contact.contactId);
                              }
                            });
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 48.w,
                                height: 48.w,
                                padding: EdgeInsets.all(3.w),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.green
                                        : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 24.r,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage:
                                      imageProvider ??
                                      const AssetImage(
                                        AppImages.defaultUserProfile,
                                      ),
                                ),
                              ),
                              SizedBox(height: 6.h),
                              SizedBox(
                                width: 56.w,
                                child: Text(
                                  contact.fullName,
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 11.sp,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        if (widget.retakeUrl != null) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          useRootNavigator: true,
          backgroundColor: Colors.transparent,
          builder: (context) => const FractionallySizedBox(
            heightFactor: 0.95,
            child: GalleryBottomSheet(),
          ),
        ).then((_) => _onModalClosed());
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        margin: EdgeInsets.only(bottom: 30.h),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32.w,
              height: 32.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.photo_library_outlined,
                color: Colors.white,
                size: 20.w,
              ),
            ),
            SizedBox(width: 12.w),
            Text(
              'Galeri',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 24.sp),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    IconData? icon,
    String? imageAsset,
    required String label,
    required bool isSelected,
    Color? iconBackgroundColor,
    required VoidCallback onTap,
  }) {
    final borderColor = isSelected
        ? const Color(0xFF00A735)
        : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(2.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: borderColor, width: 2),
              ),
              child: icon != null
                  ? CircleAvatar(
                      radius: 20,
                      backgroundColor: iconBackgroundColor,
                      child: Icon(icon, color: Colors.white70, size: 20.sp),
                    )
                  : CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(imageAsset!),
                    ),
            ),
            SizedBox(height: 8.h),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                color: Colors.white70,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildDropdown(BuildContext context) {
    return BlocBuilder<ChildrenCacheCubit, List<dynamic>>(
      builder: (context, children) {
        if (children.isEmpty) {
          return const SizedBox.shrink();
        }

        // Safely constrain index
        final safeIndex = _selectedChildIndex < children.length
            ? _selectedChildIndex
            : 0;
        final activeChild = children[safeIndex];

        return PopupMenuButton<int>(
          color: const Color(0xFF333333),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          offset: Offset(0, 48.h),
          onSelected: (index) {
            setState(() {
              _selectedChildIndex = index;
            });
          },
          itemBuilder: (context) {
            return List.generate(children.length, (index) {
              final child = children[index];
              return PopupMenuItem<int>(
                value: index,
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundColor: const Color(
                        0xFF00A735,
                      ).withValues(alpha: 0.2),
                      backgroundImage:
                          ImageHelper.getSafeImageProvider(child.imagePath) ??
                          ImageHelper.getDefaultChildImage(child.gender),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      child.name,
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              );
            });
          },
          child: CircleAvatar(
            radius: 18.r,
            backgroundColor: const Color(0xFF00A735).withValues(alpha: 0.2),
            backgroundImage:
                ImageHelper.getSafeImageProvider(activeChild.imagePath) ??
                ImageHelper.getDefaultChildImage(activeChild.gender),
          ),
        );
      },
    );
  }
}
