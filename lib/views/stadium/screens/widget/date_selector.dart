import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport/utilits/responsive.dart';

class CustomDateSelector extends StatelessWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;

  const CustomDateSelector({super.key, 
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Responsive.screenHeight(context) * 0.13,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: lastDate.difference(firstDate).inDays + 1,
        itemBuilder: (context, index) {
          final date = firstDate.add(Duration(days: index));
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          return GestureDetector(
            onTap: () {
              onDateSelected(date);
              print('Selected Date: $formattedDate');
            },
            child: Container(
              height: Responsive.screenHeight(context) * 0.13,
              width: Responsive.screenWidth(context) * 0.3,
              margin: EdgeInsets.symmetric(
                horizontal: Responsive.screenWidth(context) * 0.02,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: selectedDate == firstDate ? Colors.green : (selectedDate == date ? Colors.red : Colors.grey),
              ),
              child: Center(
                child: Text(
                  formattedDate,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: selectedDate == firstDate ? Colors.white : (selectedDate == date ? Colors.white : Colors.black),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}