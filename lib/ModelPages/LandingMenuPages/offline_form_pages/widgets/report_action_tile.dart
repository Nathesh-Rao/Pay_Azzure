import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportActionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDisabled; // Controls the Internet/Offline state

  const ReportActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Get.width > 600;

// Purple/Indigo

    final textColor = isDisabled ? Colors.grey.shade600 : Colors.white;
    final iconBgColor = isDisabled
        ? Colors.black.withOpacity(0.05)
        : Colors.white.withOpacity(0.18);
    final iconColor = isDisabled ? Colors.grey.shade500 : Colors.white;

    return AspectRatio(
      aspectRatio: 1,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: isDisabled ? null : onTap, // Disable click if offline
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),

              // gradient: LinearGradient(
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              //   colors: gradientColors,
              // ),

              image: DecorationImage(
                  colorFilter: isDisabled
                      ? ColorFilter.mode(Colors.grey, BlendMode.color)
                      : null,
                  image: AssetImage("assets/images/report_bg.png")),
              boxShadow: isDisabled
                  ? []
                  : [
                      BoxShadow(
                        color: const Color(0xFF4F46E5).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
            ),
            padding: const EdgeInsets.all(14),
            child: Stack(
              children: [
                // === MAIN COLUMN ===
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon Bubble
                    Container(
                      width: isTablet ? 84 : 42,
                      height: isTablet ? 84 : 42,
                      decoration: BoxDecoration(
                        color: iconBgColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        icon,
                        size: isTablet ? 44 : 22,
                        color: iconColor,
                      ),
                    ),

                    const Spacer(),

                    // Title Bubble
                    Container(
                      // width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(
                        color: isDisabled
                            ? Colors.white.withOpacity(0.4)
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Text(
                        title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 24 : 14,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          height: 1.2,
                        ),
                      ),
                    ),

                    // Optional Subtitle
                    if (subtitle != null && !isDisabled) ...[
                      const SizedBox(height: 6),
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(0.85),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // === DISABLED OVERLAY (CLOUD ICON) ===
                if (isDisabled)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.cloud_off_rounded,
                        size: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
