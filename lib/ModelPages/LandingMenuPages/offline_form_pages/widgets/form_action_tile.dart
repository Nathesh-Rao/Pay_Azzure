import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/models/form_page_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FormActionTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const FormActionTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.subtitle,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final Color bg = color ?? const Color(0xFF2563EB);

    final isTablet = Get.width > 600;

    return AspectRatio(
      aspectRatio: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              image: DecorationImage(
                  image: AssetImage("assets/images/card_bg_red.png"),
                  fit: BoxFit.cover)),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon bubble
              Container(
                width: isTablet ? 84 : 42,
                height: isTablet ? 84 : 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: isTablet ? 44 : 22,
                  color: Colors.white,
                ),
              ),

              const Spacer(),

              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                decoration: BoxDecoration(
                    color: Colors.white.withAlpha(50),
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: isTablet ? 24 : 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),

              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
