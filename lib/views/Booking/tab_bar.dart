import 'package:flutter/material.dart';
import 'package:sport/app/app_packges.dart';
import '../../utilits/responsive.dart';
import 'booking_history_screen.dart';
import 'current_book_screen.dart';

class CoustomTapBar extends StatelessWidget {
  const CoustomTapBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(
                height: Responsive.screenHeight(context) * 0.07,
                child: TabBar(
                  labelStyle: TextStyle(
                    fontFamily: GoogleFonts.cairo().fontFamily,
                    fontSize: Responsive.textSize(context, 16),
                  ),
                  // Customize the selected tab text size
                  unselectedLabelStyle: TextStyle(
                      fontFamily: GoogleFonts.cairo().fontFamily,
                      fontSize: Responsive.textSize(context, 12)),
                  // Customize the unselected ta
                  tabs: const [
                    Tab(
                      text: 'الحجوزات الحالية',
                    ),
                    Tab(text: 'سجل حجوزاتك'),
                  ],
                ),
              ),
              const Expanded(
                child: TabBarView(
                  children: [
                    CurrentBooking(), BookingHistoryScreen()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
