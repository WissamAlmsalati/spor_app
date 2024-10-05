import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../utilits/constants.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double? hintSize;
  final String validatorText;
  final double? labelSize;
  final double? validatorSize;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool showForgotPassword;
  final VoidCallback? onForgotPassword;
  final bool obscureText;
  final FocusNode? focusNode; // Added FocusNode

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.validatorText,
    this.validator,
    this.keyboardType,
    this.hintSize,
    this.labelSize,
    this.validatorSize,
    this.showForgotPassword = false,
    this.onForgotPassword,
    this.obscureText = false,
    this.focusNode, // Added FocusNode
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> _obscureTextNotifier = ValueNotifier<bool>(obscureText);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Constants.txtColor
          )
        ),
        SizedBox(height: Responsive.screenHeight(context) * 0.01),
        Container(
          height: Responsive.screenHeight(context) * 0.08 - 2,
          child: ValueListenableBuilder<bool>(
            valueListenable: _obscureTextNotifier,
            builder: (context, _obscureText, child) {
              return TextFormField(
                cursorColor: Constants.mainColor,
                focusNode: focusNode, // Assigned FocusNode here
                keyboardType: keyboardType ?? TextInputType.text,
                controller: controller,
                obscureText: _obscureText,
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
                    borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.02)          ,
                    borderSide: const BorderSide(
                      color: Constants.mainColor,
                      width: 1.2,
                    ),
                  ),
                  hintText: labelText,
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
                  focusedErrorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 0.8,
                    ),
                  ),
                  errorStyle: GoogleFonts.cairo(
                    color: Colors.red,
                    fontSize: validatorSize,
                    fontWeight: FontWeight.bold,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 8.0,
                  ),
                  suffixIcon: obscureText
                      ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _obscureTextNotifier.value = !_obscureTextNotifier.value;
                    },
                  )
                      : null,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: hintSize,
                ),
                validator: (value) {
                  return validator?.call(value) ?? (value == null || value.isEmpty ? validatorText : null);
                },
              );
            },
          ),
        ),
        if (showForgotPassword)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: onForgotPassword,
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
