import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AllRecordsDoneDialog extends StatelessWidget {
  const AllRecordsDoneDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Spacer(),
              IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(CupertinoIcons.clear_circled_solid))
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  child: Center(
                    child: Lottie.asset(
                      height: 200,
                      "assets/lotties/success.json",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _infoBox(
                    icon: Icons.cloud_done_sharp,
                    message:
                        "All of your records updated with refreshing Pending Queues ",
                    color: Colors.green),
                const SizedBox(height: 8),
                _infoBox(
                    icon: Icons.cloud_done_sharp,
                    message: "0 records to push\n"
                        "You can close this dialog",
                    color: Colors.orange)
              ],
            ),
          ),
        ],
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
        color: color.withValues(alpha: 0.02),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
