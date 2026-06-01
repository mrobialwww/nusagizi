import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nusagizi/core/domain/entities/child_profile.dart';
import 'package:nusagizi/core/domain/entities/growth_record.dart';

class HeaderGrowthDevelopment extends StatelessWidget {
  final ChildProfile profile;
  final GrowthRecord latest;
  final VoidCallback onPickerTapped;
  final VoidCallback onHistoryTapped;
  final Color accentColor;

  const HeaderGrowthDevelopment({
    super.key,
    required this.profile,
    required this.latest,
    required this.onPickerTapped,
    required this.onHistoryTapped,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Tombol Back
          GestureDetector(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              size: 24,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 16),

          // 2. Profil Anak (Dapat diklik untuk membuka picker)
          Expanded(
            child: GestureDetector(
              onTap: onPickerTapped,
              child: Container(
                color: Colors.transparent, // Memperbesar area klik
                child: Row(
                  children: [
                    // Avatar dengan Dashed Border
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: accentColor.withOpacity(0.2),
                        child: Text(
                          profile.name[0],
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold,
                            color: accentColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Nama dan Umur
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            profile.name,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            profile.ageString,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 3. Tombol Riwayat (History)
          GestureDetector(
            onTap: onHistoryTapped,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 22,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
