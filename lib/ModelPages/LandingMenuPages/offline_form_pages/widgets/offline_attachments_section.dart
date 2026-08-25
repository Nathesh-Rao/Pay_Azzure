import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controller/offline_form_controller.dart';

class OfflineAttachmentsSection extends GetView<OfflineFormController> {
  const OfflineAttachmentsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.attachments.isEmpty) {
        return const SizedBox.shrink();
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 10,
        children: [
          SizedBox.shrink(),
          _label("Attachments"),
          SizedBox(
            height: 56, // compact height
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.attachments.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) {
                final file = controller.attachments[index];

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    // color: controller
                    //     .getAttachmentColor(file.extension)
                    //     .withValues(alpha: 0.1),
                    color: Colors.grey.shade100,
                    border: Border.all(
                      // color: controller
                      //     .getAttachmentColor(file.extension)
                      //     .withValues(alpha: 0.4),
                      color: Colors.grey.shade300,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        controller.getAttachmentIcon(file.extension),
                        size: 18,
                        color: controller.getAttachmentColor(file.extension),
                      ),
                      const SizedBox(width: 6),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 120),
                        child: Text(
                          file.name,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => controller.removeAttachment(file),
                        child: const Icon(
                          CupertinoIcons.clear_circled_solid,
                          size: 16,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _label(String label) {
    return Row(
      spacing: 5,
      children: [
        Icon(
          CupertinoIcons.paperclip,
          size: 14,
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          ": ${controller.getAttachmentTypeSummary()}",
          style: GoogleFonts.poppins(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: MyColors.AXMGray,
          ),
        ),
      ],
    );
  }
}
