import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../utilits/constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labeltext;
  final double? hintSize;
  final String validatorText;
  final bool isPasswordField;
  final double? lableSize;
  final double? validatorSize;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.validatorText,
    this.isPasswordField = false,
    this.validator,
    this.keyboardType,
    this.hintSize,
    this.lableSize,
    this.validatorSize,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.labeltext,
          style: TextStyle(
            fontFamily: GoogleFonts.cairo().fontFamily,
            color: Constants.txtColor,
            fontWeight: FontWeight.w500,
            fontSize: widget.lableSize ?? 18,
          ),
        ),
        SizedBox(height: Responsive.screenHeight(context) * 0.01),
        Container(
          height: Responsive.screenHeight(context) * 0.06,
          child: TextFormField(
            keyboardType: widget.keyboardType ?? TextInputType.text,
            controller: widget.controller,
            obscureText: widget.isPasswordField ? _obscureText : false,
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
              hintText: widget.labeltext,
              hintStyle: TextStyle(
                color: Constants.thirdColor,
                fontSize: widget.hintSize ?? 14,
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
                fontSize: widget.validatorSize,
                fontWeight: FontWeight.bold,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 2.0,
                horizontal: 8.0,
              ),
              suffixIcon: widget.isPasswordField
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: widget.hintSize,
            ),
            validator: widget.validator ?? (value) {
              if (value == null || value.isEmpty) {
                return widget.validatorText;
              }
              if (widget.isPasswordField && !validatePassword(value)) {
                return 'Password must be at least 8 characters long, contain an uppercase letter, and a mix of numbers and letters.';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  bool validatePassword(String password) {
    final minLength = 8;
    final hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);
    final hasNumber = RegExp(r'[0-9]').hasMatch(password);
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(password);

    return password.length >= minLength && hasUpperCase && hasNumber && hasLetter;
  }
}