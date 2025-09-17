import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'WidgetRotatingSuffixField.dart';

class WidgetLoginTextField extends StatefulWidget {
  const WidgetLoginTextField({
    super.key,
    required this.label,
    this.controller,
    this.errorText,
    this.hintText,
    this.suffixIcon,
    this.obscureText = false,
    this.isLoading = false,
    this.readOnly = false,
    this.focusNode,
    this.onTap,
  });

  final String label;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final String? errorText;
  final bool obscureText;
  final bool isLoading;
  final bool readOnly;
  final String? hintText;
  final FocusNode? focusNode;
  final void Function()? onTap;

  @override
  State<WidgetLoginTextField> createState() => _WidgetLoginTextFieldState();
}

class _WidgetLoginTextFieldState extends State<WidgetLoginTextField> {
  late bool _isObscured;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isPasswordField = widget.obscureText;
    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label,
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 10),
          Stack(
            children: [
              TextFormField(
                focusNode: widget.focusNode,
                controller: widget.controller,
                readOnly: !widget.isLoading ? widget.readOnly : widget.isLoading,
                obscureText: _isObscured,//widget.obscureText,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                onTap: widget.onTap,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xffC4C4C4),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  //

                  //
                  hintText: widget.hintText,
                  hintStyle: GoogleFonts.manrope(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),

                  //
                ),
              ),
              //Positioned(right: 20, top: 0, bottom: 0, child: widget.isLoading ? WidgetRotatingSuffixField() : widget.suffixIcon ?? SizedBox.shrink())
              Positioned(
                right: 20,
                top: 0,
                bottom: 0,
                child: widget.isLoading
                    ? const WidgetRotatingSuffixField()
                    : isPasswordField
                        ? IconButton(
                            onPressed: _toggleObscure,
                            icon: Icon(
                              _isObscured ? Icons.visibility_off : Icons.visibility,
                              color: Colors.grey,
                            ),
                          )
                        : widget.suffixIcon ?? const SizedBox.shrink(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
