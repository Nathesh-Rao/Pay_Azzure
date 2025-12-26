import 'package:axpertflutter/Constants/Extensions.dart';
import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key, this.width, this.label});
  final double? width;
  final String? label;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/no-data.png",
          width: width ?? MediaQuery.of(context).size.width / 3,
        ),
        10.verticalSpace,
        Text(
          label ?? "No Data Found",
          style: GoogleFonts.poppins(
            color: MyColors.primaryTitleTextColorBlueGrey,
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
