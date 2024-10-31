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

  final List<String> hours = List.generate(12, (index) => '${index + 1}:00');
  final List<String> periods = ['ص', 'م'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: Responsive.screenHeight(context) * 0.109,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(hours.length * periods.length, (index) {
            final hour = hours[index % hours.length];
            final period = periods[index ~/ hours.length];
            final displayTime = '$hour $period';
            final formattedTime = period == 'م' ? '${int.parse(hour.split(':')[0]) + 12}:00:00' : '$hour:00';
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
              child: SizedBox(
                width: Responsive.screenWidth(context) * 0.19,
                height: Responsive.screenHeight(context) * 0.10,
                child: Card(
                  color: index == selectedIndex ? Constants.mainColor : null,
                  elevation: 2,
                  margin: EdgeInsets.only(right: Responsive.screenWidth(context) * 0.02),
                  child: Center(
                    child: Text(
                      displayTime,
                      style: TextStyle(
                        color: index == selectedIndex ? Colors.white : null,
                        fontSize: Responsive.textSize(context, 12),
                      ),
                    ),
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