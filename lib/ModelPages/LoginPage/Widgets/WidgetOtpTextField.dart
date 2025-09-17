import 'package:axpertflutter/Constants/MyColors.dart';
import 'package:axpertflutter/ModelPages/LoginPage/Widgets/WidgetRotatingSuffixField.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pinput/pinput.dart';

class WidgetOtpTextField extends StatelessWidget {
  WidgetOtpTextField({
    super.key,
    required this.label,
    this.isLoading = false,
    this.width = 10,
    this.otpLength = 4,
    this.controller,
    this.errorText = '',
    this.onCompleted,

  });

  final String label;
  final bool isLoading;
  final double width;
  final int otpLength;
  final TextEditingController? controller;
  final String errorText;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    var fieldSize = MediaQuery.of(context).size.width * 0.112;

    final PinTheme defaultTheme = PinTheme(
      margin: EdgeInsets.symmetric(horizontal: 7),
      width: fieldSize,
      height: fieldSize,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final PinTheme errorTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    return Padding(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              isLoading
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        WidgetRotatingSuffixField(
                          width: 15,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  : SizedBox.shrink(),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          // OTPTextField(
          //   length: 6,
          //   width: MediaQuery.of(context).size.width - 50,
          //   fieldWidth: MediaQuery.of(context).size.width * 0.116,
          //   textFieldAlignment: MainAxisAlignment.spaceBetween,
          //   fieldStyle: FieldStyle.box,
          //   onCompleted: (pin) {
          //     print("Completed: " + pin);
          //   },
          // ),
          Center(
            child: Pinput(
              length: otpLength,
              controller: controller,
              defaultPinTheme: errorText.isNotEmpty ? errorTheme : defaultTheme,
             /* validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'PIN is required';
                } else if (value.length < 4) {
                  return 'PIN must be 4 digits';
                }
                return null;
              },*/
              // errorText: errorText.isEmpty ? null : errorText,
              //errorTextStyle: TextStyle(color: Colors.red, fontSize: 12),
              focusedPinTheme: PinTheme(
                margin: EdgeInsets.symmetric(horizontal: 7),
                width: fieldSize,
                height: fieldSize,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.PayAzzureColor2, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              submittedPinTheme: PinTheme(
                margin: EdgeInsets.symmetric(horizontal: 7),
                width: fieldSize,
                height: fieldSize,
                decoration: BoxDecoration(
                  border: Border.all(color: MyColors.PayAzzureColor2, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),

              onCompleted: (pin) => onCompleted!(),
            ),
          ),
          errorText.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(left: 50, top: 10),
                  child: Text(
                    errorText,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : const SizedBox.shrink(),
          /* Text(
            errorText,
            style: TextStyle(color: Colors.red),
          )*/
        ],
      ),
    );
  }
}
