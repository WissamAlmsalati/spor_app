
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utilits/responsive.dart';

import '../../../utilits/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labeltext;
  final double? hintSize;
  final String validatorText;
  final bool isPasswordField;
  final double? lableSize;
  final double? validatorSize;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const
  CustomTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.validatorText,
    this.isPasswordField = false,
    this.validator,
    this.keyboardType, this.hintSize, this.lableSize, this.validatorSize,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labeltext,
          style: TextStyle(
            color: Constants.txtColor,
            fontWeight: FontWeight.w500,
            fontSize: lableSize ?? 18,
          ),
        ),
        SizedBox(height: Responsive.screenHeight(context) * 0.01),
        Container(
          height: Responsive.screenHeight(context) * 0.06,

          child: TextFormField(
            keyboardType: keyboardType ?? TextInputType.text,
            controller: controller,
            obscureText: isPasswordField,
            decoration: InputDecoration(
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.02),
                borderSide: const BorderSide(
                  color: Constants.thirdColor,
                  width: 0.5,
                ),

              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: const BorderSide(
                  color: Constants.mainColor,
                  width: 1.2,
                ),
              ),
              hintText: labeltext,
              hintStyle: TextStyle(
                color: Constants.thirdColor,
                fontSize: hintSize ?? 14,
                fontFamily: GoogleFonts.cairo().fontFamily,
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1.1,
                ),
              ),
              errorStyle: GoogleFonts.cairo(
                color: Colors.red,
                fontSize: validatorSize,
                fontWeight: FontWeight.bold, // Custom style for validator text
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
            ),
            style:  TextStyle(
              color: Colors.black,
              fontSize: hintSize,
            ),
            validator: validator ?? (value) {
              if (value == null || value.isEmpty) {
                return validatorText;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}