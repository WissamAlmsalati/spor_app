import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sport/utilits/responsive.dart';
import '../../../utilits/constants.dart';

class CustomDatePickerField extends StatefulWidget {
  final TextEditingController controller;
  final String labeltext;
  final double? hintSize;
  final String validatorText;
  final bool isPasswordField;
  final double? lableSize;
  final double? validatorSize;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  const CustomDatePickerField({
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
  _CustomDatePickerFieldState createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      pickedDate = await showCupertinoModalPopup<DateTime>(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: Responsive.screenHeight(context) * 0.35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(
                  height: Responsive.screenHeight(context) * 0.25,
                  child: CupertinoTheme(
                    data: CupertinoThemeData(
                      textTheme: CupertinoTextThemeData(
                        pickerTextStyle: TextStyle(
                          fontFamily: GoogleFonts.cairo().fontFamily,
                          fontSize: 22,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    child: CupertinoDatePicker(
                      mode: CupertinoDatePickerMode.date,
                      initialDateTime: DateTime.now(),
                      onDateTimeChanged: (DateTime dateTime) {
                        pickedDate = dateTime;
                      },
                    ),
                  ),
                ),
                CupertinoButton(
                  child: Text(
                    'تأكيد',
                    style: TextStyle(
                      fontFamily: GoogleFonts.cairo().fontFamily,
                      color: Constants.mainColor,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(pickedDate);
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100),
      );
    }

    if (pickedDate != null) {
      setState(() {
        widget.controller.text = "${pickedDate!.year}-${pickedDate!.month.toString().padLeft(2, '0')}-${pickedDate!.day.toString().padLeft(2, '0')}";
      });
    }
  }

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
        SizedBox(
          height: Responsive.screenHeight(context) * 0.06,
          child: TextFormField(
            keyboardType: widget.keyboardType ?? TextInputType.text,
            controller: widget.controller,
            obscureText: widget.isPasswordField,
            readOnly: true,
            onTap: () => _selectDate(context),
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
            ),
            style: TextStyle(
              color: Colors.black,
              fontSize: widget.hintSize,
            ),
            validator: widget.validator ?? (value) {
              if (value == null || value.isEmpty) {
                return widget.validatorText;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
