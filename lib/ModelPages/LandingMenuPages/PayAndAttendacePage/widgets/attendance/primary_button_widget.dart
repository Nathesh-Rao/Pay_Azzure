import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool isLoading;

  const PrimaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.label,
    this.height,
    this.width,
    this.margin,
    this.labelStyle,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55,
      width: width ?? double.infinity,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: backgroundColor ?? MyColors.primaryButtonBGColorViolet,
          foregroundColor: foregroundColor ?? MyColors.primaryButtonFGColorWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: labelStyle ??
              GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
