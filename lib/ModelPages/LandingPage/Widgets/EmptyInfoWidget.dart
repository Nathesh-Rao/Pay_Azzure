import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyInfoWidget extends StatelessWidget {
  const EmptyInfoWidget({super.key, this.image, this.title, this.subTitle, this.widthFactor});
  final String? image;
  final String? title;
  final String? subTitle;
  final double? widthFactor;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Image.asset(
              image ?? "assets/images/out-of-stock.png",
              width: Get.width / (widthFactor ?? 3),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            title ?? "Title",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            subTitle ?? "Subtitle",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
