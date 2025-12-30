import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/Constants/app_styles.dart';
import 'package:flutter/material.dart';

class FlatButtonWidget extends StatelessWidget {
  const FlatButtonWidget({
    super.key,
    required this.label,
    this.color,
    this.bgColor,
    this.height,
    this.width,
    this.onTap,
    this.fontSize,
    this.isCompact = false,
  });
  final Color? color;
  final Color? bgColor;
  final String label;
  final Function()? onTap;
  final double? height;
  final double? width;
  final double? fontSize;
  final bool isCompact;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? (isCompact ? 40 : 50),
      width: width,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(5),
            elevation: 0,
            backgroundColor: (bgColor ?? color ?? MyColors.flatButtonColorBlue)
                .withAlpha(50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            )),
        onPressed: onTap,
        child: Text(
          label,
          style: AppStyles.textButtonStyleNormal.copyWith(
              color: color ?? MyColors.flatButtonColorBlue,
              fontSize: isCompact ? 11.5 : fontSize,
              fontWeight: isCompact ? FontWeight.w500 : null),
        ),
      ),
    );
  }
}
