import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:flutter/material.dart';

class SecondaryButtonWidget extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final TextStyle? labelStyle;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const SecondaryButtonWidget({
    super.key,
    required this.onPressed,
    required this.child,
    this.height,
    this.width,
    this.margin,
    this.labelStyle,
    this.backgroundColor,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55,
      width: width ?? double.infinity,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 25),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              backgroundColor ?? MyColors.secondaryButtonBGColorWhite,
          foregroundColor:
              foregroundColor ?? MyColors.secondaryButtonFGColorViolet,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: MyColors.secondaryButtonBorderColorGrey),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: child,
      ),
    );
  }
}
