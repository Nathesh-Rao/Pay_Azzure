import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WidgetLoginButton extends StatelessWidget {
  WidgetLoginButton({super.key, required this.label, required this.onPressed, this.visible = true});

  final String label;
  bool visible;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 25),
        height: MediaQuery.of(context).size.height * 0.065,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          onPressed: onPressed,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
