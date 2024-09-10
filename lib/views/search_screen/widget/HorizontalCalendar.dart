import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/app_packges.dart';



class DateSelector extends StatelessWidget {
  final List<String> dates;
  final String selectedDate;
  final ValueChanged<String> onDateSelected;

  DateSelector({
    required this.dates,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dates.map((date) {
          final isSelected = date == selectedDate;
          final dateTime = DateTime.parse(date);
          final dayName = DateFormat('EEEE', 'ar').format(dateTime);
          final dayNumber = dateTime.day.toString();

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? Constants.mainColor : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: SizedBox(
                width: Responsive.screenWidth(context) * 0.2,
                height: Responsive.screenHeight(context) * 0.1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: Responsive.textSize(context, 16),
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                    Text(
                      dayNumber,
                      style: TextStyle(
                        fontSize: Responsive.textSize(context, 20),
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
