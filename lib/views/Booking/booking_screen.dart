import 'package:flutter/material.dart';
import 'package:sport/views/Booking/tab_bar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  BookingScreenState createState() => BookingScreenState();
}

class BookingScreenState extends State<BookingScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        children: [
          Expanded(
            child: CoustomTapBar(),
          ),
        ],
      ),
    );
  }
}
