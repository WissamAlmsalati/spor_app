import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';

class DateSelector extends StatelessWidget {
  final List<String> dates;
  final String selectedDate;
  final Function(String) onDateSelected;

  const DateSelector({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  }) : super(key: key);

  String getDayName(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('EEEE', 'ar').format(dateTime);
  }

  String getDayNumber(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('d').format(dateTime);
  }

  String getMonthName(String date) {
    DateTime dateTime = DateTime.parse(date);
    return DateFormat('MMMM', 'ar').format(dateTime);  // Format the month name in Arabic
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dates.map((date) {
          final isSelected = date == selectedDate;
          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              width: Responsive.screenWidth(context) * 0.2,
              height: Responsive.screenHeight(context) * 0.11,  // Adjust height to accommodate the month name
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    getMonthName(date),  // Display the month name
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 12),
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    getDayName(date),
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 12),
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    getDayNumber(date),
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 14),
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
