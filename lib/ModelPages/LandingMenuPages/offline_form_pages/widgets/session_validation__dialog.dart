import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:axpertflutter/ModelPages/LandingMenuPages/offline_form_pages/controller/offline_form_controller.dart';

enum CachedSessionValidationResult {
  valid,
  invalid,
}

class CachedSessionValidationDialog extends GetView<OfflineFormController> {
  const CachedSessionValidationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final valid = await controller.validateSession();
        print("CachedSessionValidationDialog session is $valid");

        if (Get.isDialogOpen ?? false) {
          Get.back(
            result: valid
                ? CachedSessionValidationResult.valid
                : CachedSessionValidationResult.invalid,
          );
        }
      } catch (_) {
        print("CachedSessionValidationDialog caught an error");

        if (Get.isDialogOpen ?? false) {
          Get.back(result: CachedSessionValidationResult.invalid);
        }
      }
    });

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 200,
              child: Center(
                child: Lottie.asset(
                  "assets/lotties/validate_session.json",
                ),
              ),
            ),
            const SizedBox(height: 16),
            _infoBox(
                icon: Icons.security,
                message: "We are validating your session\n"
                    "Please hold on",
                color: Color(0xffF59E0B))
          ],
        ),
      ),
    );
  }

  Widget _infoBox(
      {required IconData icon, required String message, required Color color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
