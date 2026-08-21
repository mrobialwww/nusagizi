import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/di/service_locator.dart';
import 'package:nusagizi/features/mother/home/presentation/cubit/children_cache_cubit.dart';

class ChildAvatar extends StatelessWidget {
  const ChildAvatar({super.key, required this.name, this.size = 20});

  final String name;
  final double size;

  static const double _initialFontRatio = 0.55;
  static const List<Color> _palette = [
    Color(0xFFFF7F00),
    Color(0xFF007BFF),
    Color(0xFFE91E63),
    Color(0xFF4CAF50),
    Color(0xFF9C27B0),
    Color(0xFFFF5722),
    Color(0xFF00BCD4),
    Color(0xFFFFB300),
  ];

  String? _resolveImagePath() {
    final target = name.trim().toLowerCase();
    for (final child in sl<ChildrenCacheCubit>().state) {
      final childName = child.name.trim().toLowerCase();
      final isMatch =
          childName == target ||
          childName.contains(target) ||
          target.contains(childName);
      if (isMatch) {
        return child.imagePath.isNotEmpty ? child.imagePath : null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _resolveImagePath();
    if (imagePath == null) return _buildInitialAvatar();

    final image = imagePath.startsWith('http')
        ? Image.network(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildInitialAvatar(),
          )
        : Image.asset(
            imagePath,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildInitialAvatar(),
          );

    return ClipOval(
      child: SizedBox(width: size.w, height: size.w, child: image),
    );
  }

  Widget _buildInitialAvatar() {
    final hash = name.trim().toLowerCase().hashCode.abs();
    final color = _palette[hash % _palette.length];
    return Container(
      width: size.w,
      height: size.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Text(
        name.trim()[0].toUpperCase(),
        style: GoogleFonts.outfit(
          fontSize: (size * _initialFontRatio).sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
