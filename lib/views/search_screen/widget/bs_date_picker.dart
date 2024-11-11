import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/responsive.dart';

class CalendarRow extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const CalendarRow({super.key, required this.onDateSelected});

  @override
  _CalendarRowState createState() => _CalendarRowState();
}

class _CalendarRowState extends State<CalendarRow> {
  int? selectedIndex;

  final List<DateTime> days = List.generate(30, (index) {
    return DateTime.now().add(Duration(days: index));
  });

  @override
  Widget build(BuildContext context) {
    final availableDays = days;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(availableDays.length, (index) {
          final dayName = DateFormat.EEEE('ar').format(availableDays[index]);
          final dayNumber = DateFormat.d('en').format(availableDays[index]);
          final monthName = DateFormat.MMMM('ar').format(availableDays[index]);
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onDateSelected(availableDays[index]);
              String formattedDate = DateFormat('yyyy-MM-dd').format(availableDays[index]);
              if (kDebugMode) {
                print('Selected Date: $formattedDate');
              }
            },
            child: Container(
              width: Responsive.screenWidth(context) * 0.21,
              height: Responsive.screenHeight(context) * 0.11,
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
                    monthName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    dayName,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    dayNumber,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}