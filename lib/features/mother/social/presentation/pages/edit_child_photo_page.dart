import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:nusagizi/router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'package:nusagizi/core/di/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/contacts_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/edit_child_photo_cubit.dart';
import 'package:nusagizi/features/mother/social/presentation/cubit/edit_child_photo_state.dart';
import 'package:nusagizi/features/mother/social/data/models/edit_child_photo_request_model.dart';
import 'package:nusagizi/core/utils/image_helper.dart';

class EditChildPhotoPage extends StatefulWidget {
  final String? photoId;
  final String imageUrl;
  final String? childId;

  const EditChildPhotoPage({
    super.key,
    required this.photoId,
    required this.imageUrl,
    this.childId,
  });

  @override
  State<EditChildPhotoPage> createState() => _EditChildPhotoPageState();
}

class _EditChildPhotoPageState extends State<EditChildPhotoPage> {
  String _visibilityMode = 'all';
  final List<String> _selectedContactIds = [];
  final TextEditingController _captionController = TextEditingController();

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.photoId == null) {
      return const Scaffold(
        backgroundColor: Color(0xFF1E1E1E),
        body: Center(
          child: Text(
            "Invalid Photo ID",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<ContactsCubit>()..fetchContacts()),
      ],
      child: BlocListener<EditChildPhotoCubit, EditChildPhotoState>(
        listener: (context, state) {
          if (state is EditChildPhotoSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Foto berhasil diperbarui & disetujui'),
              ),
            );
            context.goNamed(AppRoutes.socialMother.name);
          } else if (state is EditChildPhotoError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
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
                    _buildPhotoPreview(),
                    SizedBox(height: 40.h),
                    _buildControls(),
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      child: SizedBox(
        height: 48.h,
        child: Center(
          child: Text(
            'Edit Foto',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPreview() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0.w),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(36.r),
              child: SizedBox.expand(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[800]!,
                    highlightColor: Colors.grey[700]!,
                    child: Container(color: Colors.white),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[850],
                    child: const Icon(
                      Icons.broken_image,
                      color: Colors.white54,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: TextField(
                  controller: _captionController,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Tambah pesan',
                    hintStyle: GoogleFonts.inter(
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

  Widget _buildControls() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.0.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              context.pop();
            },
            icon: Icon(Icons.close, color: Colors.white, size: 36.sp),
          ),
          BlocBuilder<EditChildPhotoCubit, EditChildPhotoState>(
            builder: (context, state) {
              if (state is EditChildPhotoLoading) {
                return Container(
                  width: 85.w,
                  height: 85.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3D3D3D),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }
              return GestureDetector(
                onTap: () {
                  String visibility = _visibilityMode;
                  List<String>? listVisibility = _selectedContactIds.isNotEmpty
                      ? _selectedContactIds
                      : null;

                  if (visibility == 'selected_only' && listVisibility == null) {
                    visibility = 'private';
                  }

                  context.read<EditChildPhotoCubit>().submitEdit(
                    EditChildPhotoRequestModel(
                      childId: widget.childId ?? '',
                      childPhotoId: widget.photoId!,
                      caption: _captionController.text.trim(),
                      visibility: visibility,
                      listVisibility: listVisibility,
                      isReviewRequired: false,
                    ),
                  );
                },
                child: Container(
                  width: 85.w,
                  height: 85.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3D3D3D),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, color: Colors.white, size: 36.sp),
                ),
              );
            },
          ),
          SizedBox(width: 36.sp), // Placeholder to keep center alignment
        ],
      ),
    );
  }

  Widget _buildBottomAction(BuildContext context) {
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
                    final fallbackInitial = ImageHelper.getInitials(
                      contact.fullName,
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
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: imageProvider != null
                                      ? DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  color: imageProvider == null
                                      ? ImageHelper.getAvatarColor(
                                          contact.fullName,
                                        )
                                      : null,
                                ),
                                child: imageProvider == null
                                    ? Center(
                                        child: Text(
                                          fallbackInitial,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            SizedBox(
                              width: 56.w,
                              child: Text(
                                contact.fullName,
                                style: TextStyle(
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
              style: GoogleFonts.inter(
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
}
