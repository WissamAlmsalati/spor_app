import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/responsive.dart';

class HourRow extends StatefulWidget {
  final Function(String, String) onHourSelected; // Update the callback to pass both display time and formatted time
  final DateTime? selectedDate;

  const HourRow({super.key, required this.onHourSelected, required this.selectedDate});

  @override
  _HourRowState createState() => _HourRowState();
}

class _HourRowState extends State<HourRow> {
  int? selectedIndex;

  final List<String> hours = List.generate(12, (index) => '${index + 1}');
  final List<String> periods = ['ص', 'م'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(hours.length * periods.length, (index) {
          final hour = hours[index % hours.length];
          final period = periods[index ~/ hours.length];
          final displayTime = '$hour $period';
          final formattedTime = period == 'م' ? '${int.parse(hour) + 12}:00:00' : '$hour:00:00';
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
              widget.onHourSelected(displayTime, formattedTime);
              if (kDebugMode) {
                print('Selected Hour: $displayTime');
              }
            },
            child: Container(
              width: Responsive.screenWidth(context) * 0.2,
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
              child: Center(
                child: Text(
                  displayTime,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}