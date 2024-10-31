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
      child: SizedBox(
        height: Responsive.screenHeight(context) * 0.109,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(availableDays.length, (index) {
            final dayName = DateFormat.EEEE('ar').format(availableDays[index]);
            final dayNumber = DateFormat.d('en').format(availableDays[index]);
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
              child: SizedBox(
                width: Responsive.screenWidth(context) * 0.19,
                height: Responsive.screenHeight(context) * 0.10,
                child: Card(
                  color: index == selectedIndex ? Constants.mainColor : null,
                  elevation: 2,
                  margin: EdgeInsets.only(right: Responsive.screenWidth(context) * 0.02),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayName,
                        style: TextStyle(
                          color: index == selectedIndex ? Colors.white : null,
                          fontSize: Responsive.textSize(context, 12),
                        ),
                      ),
                      Text(
                        dayNumber,
                        style: TextStyle(
                          color: index == selectedIndex ? Colors.white : null,
                          fontSize: Responsive.textSize(context, 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}