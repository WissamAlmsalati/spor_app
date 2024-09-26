import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../utilits/constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String labeltext;
  final double? hintSize;
  final String validatorText;
  final double? lableSize;
  final double? validatorSize;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool showForgotPassword;
  final VoidCallback? onForgotPassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.labeltext,
    required this.validatorText,
    this.validator,
    this.keyboardType,
    this.hintSize,
    this.lableSize,
    this.validatorSize,
    this.showForgotPassword = false,
    this.onForgotPassword,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _hasError = false;

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
          height: (_hasError
              ? Responsive.screenHeight(context) * 0.07
              : Responsive.screenHeight(context) * 0.08) - 2,
          child: TextFormField(
            keyboardType: widget.keyboardType ?? TextInputType.text,
            controller: widget.controller,
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
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 0.8,
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
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: widget.hintSize,
            ),
            validator: (value) {
              final error = widget.validator?.call(value) ?? (value == null || value.isEmpty ? widget.validatorText : null);
              setState(() {
                _hasError = error != null;
              });
              return error;
            },
          ),
        ),
        if (widget.showForgotPassword)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: widget.onForgotPassword,
              style: ButtonStyle(
                padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                minimumSize: MaterialStateProperty.all<Size>(Size.zero),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'نسيت كلمة المرور؟',
                style: TextStyle(
                  fontFamily: GoogleFonts.cairo().fontFamily,
                  color: Constants.mainColor,
                  fontSize: Responsive.textSize(context, 10),
                ),
              ),
            ),
          ),
      ],
    );
  }
}