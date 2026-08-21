import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HeaderBasic extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool centerTitle;
  final VoidCallback? onBackPressed;
  final Color? textColor;
  final Color? iconColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final bool automaticallyImplyLeading;

  const HeaderBasic({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.backgroundColor = Colors.transparent,
    this.centerTitle = true,
    this.onBackPressed,
    this.textColor,
    this.iconColor,
    this.systemOverlayStyle,
    this.automaticallyImplyLeading = true,
  });

  // Tinggi standar AppBar (ditambah sedikit penyesuaian responsif jika perlu)
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 5.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: centerTitle,
      titleSpacing: centerTitle ? null : 0,
      systemOverlayStyle: systemOverlayStyle,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: onBackPressed != null
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: iconColor ?? Colors.black87),
              onPressed: onBackPressed,
            )
          : null,

      iconTheme: IconThemeData(color: iconColor ?? Colors.black87),
      title: Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 20.sp,
              fontWeight: FontWeight.w500,
              color: textColor ?? Colors.black87,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 2.h),
            Text(
              subtitle!,
              style: GoogleFonts.outfit(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: textColor?.withValues(alpha: 0.7) ?? Colors.black54,
              ),
            ),
          ],
        ],
      ),

      actions: actions != null
          ? [
              ...actions!.map(
                (action) => Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Center(child: action),
                ),
              ),
            ]
          : null,
    );
  }
}
