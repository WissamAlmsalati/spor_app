import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../utilits/constants.dart';
import '../../../utilits/responsive.dart';

class SelectableTimeTile extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isReserved;
  final bool isLocked;
  final VoidCallback onTap;

  const SelectableTimeTile({
    super.key,
    required this.time,
    required this.isSelected,
    required this.isReserved,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime parsedTime = DateFormat("HH:mm:ss").parse(time);
    final String formattedTime = DateFormat("h a", 'en').format(parsedTime).replaceAll('AM', 'ص').replaceAll('PM', 'م');

    return GestureDetector(
      onTap: isReserved || isLocked
          ? null
          : () {
        print('Selected time: $formattedTime');
        onTap();
      },
      child: Stack(
        children: [
          Container(
            width: Responsive.screenWidth(context) * 0.22,
            height: Responsive.screenHeight(context) * 0.1,
            margin: const EdgeInsets.only(right: 8.0),
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            decoration: BoxDecoration(
              color: isSelected && !isLocked && !isReserved ? Constants.mainColor : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isSelected && !isLocked && !isReserved ? Constants.mainColor : Colors.white,
                width: 2.0,
              ),
            ),
            child: Column(
              mainAxisAlignment: isReserved || isLocked
                  ? MainAxisAlignment.spaceAround
                  : MainAxisAlignment.center,
              children: [
                if (isReserved || isLocked)
                  Icon(
                    Icons.lock,
                    color: Colors.black.withOpacity(0.8),
                  ),
                Text(
                  formattedTime,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: isSelected && !isLocked && !isReserved ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}