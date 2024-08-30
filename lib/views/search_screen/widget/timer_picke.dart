import 'package:intl/intl.dart';
import 'package:sport/app/app_packges.dart';

class SelectableTimeTile extends StatelessWidget {
  final String time;
  final bool isAvailable;
  final bool isSelected;
  final Function(bool) onSelected;

  const SelectableTimeTile({
    Key? key,
    required this.time,
    required this.isAvailable,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Parse the time string to a DateTime object
    final DateTime parsedTime = DateFormat('HH:mm').parse(time);

    // Format the time to 12-hour format with AM/PM
    final String formattedTime = DateFormat('hh:mm a').format(parsedTime);

    // Extract the time and period (AM/PM)
    final String displayTime = formattedTime.substring(0, 5);
    final String period = formattedTime.contains('AM') ? 'ص' : 'م';

    // Determine text color based on selection status
    final Color textColor = isSelected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        if (isAvailable) {
          onSelected(true); // Notify parent about selection
        }
      },
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? Constants.mainColor : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(displayTime, style: TextStyle(color: textColor, fontSize: Responsive.textSize(context, 14))),
            Text(period, style: TextStyle(color: textColor, fontSize: Responsive.textSize(context, 14))),
            if (!isAvailable)
              const Center(child: Icon(Icons.lock, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}