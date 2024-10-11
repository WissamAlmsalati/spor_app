import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/search_screen/widget/bs_date_picker.dart';
import 'package:sport/views/search_screen/widget/bs_hour_select.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../controller/steduim_search_cubit/stidum_search_cubit.dart';
import '../../auth/widgets/coustom_button.dart';

// Custom bottom sheet for filtering stadiums by date and time
void showCustomBottomSheet(
    BuildContext context,
    String searchText,
    Function(DateTime) onDateSelected,
    Function(int) onHourSelected) {
  showModalBottomSheet(
    backgroundColor: Constants.backGroundColor,
    context: context,
    builder: (BuildContext context) {
      return Padding(
        padding: EdgeInsets.all(Responsive.screenWidth(context) * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title: تحديد التاريخ والوقت (Select Date and Time)
            Text(
              'تحديد التاريخ والوقت',
              style: TextStyle(
                fontSize: Responsive.textSize(context, 18),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),
            Divider(),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Title: حدد التاريخ (Select Date)
            Text(
              "حدد التاريخ",
              style: TextStyle(
                fontSize: Responsive.textSize(context, 15),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Calendar to select date
            CalendarRow(
              onDateSelected: (date) {
                context.read<StadiumSearchCubit>().selectDate(date);
                onDateSelected(date);
              },
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Title: حدد الوقت (Select Time)
            Text(
              "حدد الوقت",
              style: TextStyle(
                fontSize: Responsive.textSize(context, 15),
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Hour selection row
            BlocBuilder<StadiumSearchCubit, StadiumSearchState>(
              builder: (BuildContext context, state) {
                final selectedDate = context.read<StadiumSearchCubit>().selectedDate;
                return HourRow(
                  onHourSelected: (displayTime, formattedTime) {
                    final hourParts = displayTime.split(' ');
                    final hourValue = int.parse(hourParts[0].split(':')[0]);
                    final isPM = hourParts[1] == 'م';
                    final sessionId = isPM ? hourValue + 12 : hourValue;
                    context.read<StadiumSearchCubit>().selectSessionId(sessionId);
                    context.read<StadiumSearchCubit>().selectTimeFrom(formattedTime); // Store the formatted time
                    onHourSelected(sessionId);
                  },
                  selectedDate: selectedDate,
                );
              },
            ),
            SizedBox(height: Responsive.screenHeight(context) * 0.02),

            // Confirm Button
            BlocBuilder<StadiumSearchCubit, StadiumSearchState>(
              builder: (BuildContext context, state) {
                return CustomButton(
                  onPress: () {
                    final selectedDate = context.read<StadiumSearchCubit>().selectedDate;
                    final selectedSessionId = context.read<StadiumSearchCubit>().selectedSessionId;
                    final selectedTimeFrom = context.read<StadiumSearchCubit>().selectedTimeFrom; // Retrieve the formatted time

                    // Ensure all necessary parameters are available
                    if (selectedDate != null && selectedSessionId != null && selectedTimeFrom != null) {
                      // Call the search function with the necessary parameters
                      context.read<StadiumSearchCubit>().searchStadiumsWithFilter(
                        name: searchText,
                        sessionId: selectedSessionId,
                        startDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                        endDate: DateFormat('yyyy-MM-dd').format(selectedDate),
                        timeFrom: selectedTimeFrom, // Use the formatted time
                        timeTo: selectedTimeFrom, // Use the formatted time
                      );
                    }
                    Navigator.pop(context);
                  },
                  text: 'تأكيد',
                  textSize: Responsive.textSize(context, 18),
                  color: Constants.mainColor,
                  textColor: Colors.white,
                  height: Responsive.screenHeight(context) * 0.06,
                  width: Responsive.screenWidth(context) * 0.9,
                );
              },
            ),
          ],
        ),
      );
    },
  );
}
