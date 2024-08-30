import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';

class SelectableTimeTile extends StatelessWidget {
  final String time;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableTimeTile({
    Key? key,
    required this.time,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
    final String formattedTime = DateFormat("HH:mm").format(parsedTime);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: Responsive.screenWidth(context) * 0.2,
        height: Responsive.screenHeight(context) * 0.1,
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: isSelected ? Constants.mainColor : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: isSelected ? Constants.mainColor : Colors.white,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Text(
            formattedTime,
            style: TextStyle(
              fontSize: Responsive.textSize(context, 9),
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}