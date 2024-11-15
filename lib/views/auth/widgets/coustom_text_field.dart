import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../utilits/constants.dart';
import 'package:flutter/services.dart';

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
  final bool isPhoneNumber; // New parameter to determine if it's a phone number

  const CustomTextField({
    super.key,
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
    this.isPhoneNumber = false, // Default is false
  });

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<bool> obscureTextNotifier = ValueNotifier<bool>(obscureText);

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
        SizedBox(
          height: Responsive.screenHeight(context) * 0.08 - 2,
          child: ValueListenableBuilder<bool>(
            valueListenable: obscureTextNotifier,
            builder: (context, obscureText, child) {
              return TextFormField(
                cursorColor: Constants.mainColor,
                focusNode: focusNode, // Assigned FocusNode here
                keyboardType: keyboardType ?? TextInputType.text,
                controller: controller,
                obscureText: obscureText,
                inputFormatters: isPhoneNumber
                    ? [
                  FilteringTextInputFormatter.digitsOnly, // Only allow digits
                  LengthLimitingTextInputFormatter(10), // Max length of 10
                ]
                    : [], // No restrictions for non-phone fields
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
                    borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.02),
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
                      obscureText ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      obscureTextNotifier.value = !obscureTextNotifier.value;
                    },
                  )
                      : null,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: hintSize,
                ),
                validator: (value) {
                  return validator?.call(value?.toArabicNumerals()) ?? (value == null || value.isEmpty ? validatorText : null);
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
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                minimumSize: WidgetStateProperty.all<Size>(Size.zero),
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

extension PersianToArabicNumerals on String {
  String toArabicNumerals() {
    const persianToArabicMap = {
      '۰': '0',
      '۱': '1',
      '۲': '2',
      '۳': '3',
      '۴': '4',
      '۵': '5',
      '۶': '6',
      '۷': '7',
      '۸': '8',
      '۹': '9',
    };

    return split('').map((char) => persianToArabicMap[char] ?? char).join('');
  }
}
