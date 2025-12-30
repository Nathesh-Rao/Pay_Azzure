import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class IconLabelWidget extends StatelessWidget {
  final IconData? icon;
  final Color? iconColor;
  final String label;
  final double iconSize;
  final TextStyle? textStyle;
  final double spacing;

  const IconLabelWidget({
    super.key,
    this.icon,
    this.iconColor,
    required this.label,
    this.iconSize = 15,
    this.textStyle,
    this.spacing = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon ?? Icons.circle,
          size: iconSize,
          color: iconColor,
        ),
        SizedBox(
          width: spacing,
        ),
        Text(
          label,
          style: textStyle ??
              GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
        ),
      ],
    );
  }
}
