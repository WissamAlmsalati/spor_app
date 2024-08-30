import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:animations/animations.dart';
import '../../utilits/constants.dart';
import '../../controller/NavigationCubit/NavigationCubit_cubit.dart';
import '../../utilits/images.dart';
import '../Booking/booking_screen.dart';
import '../profile/profile_screen.dart';
import '../stadium/screens/stadium_screen.dart';

class HomeNavigation extends StatelessWidget {
  HomeNavigation({super.key});

  final List<Widget> _screens = [
    const StadiumScreen(),
    const ProfileScreen(),
    const BookingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationCubit(),
      child: Scaffold(
        body: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return PageTransitionSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> primaryAnimation, Animation<double> secondaryAnimation) {
                return FadeThroughTransition(
                  animation: primaryAnimation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
              child: _screens[state],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
          builder: (context, state) {
            return BottomNavigationBar(
              currentIndex: state,
              onTap: (index) {
                context.read<NavigationCubit>().updateIndex(index, context);
              },
              items: [
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppPhotot.stadiumLogo,
                    width: 28,
                    height: 20,
                    color: state == 0 ? Constants.mainColor : Constants.thirdColor,
                  ),
                  label: 'الملاعب',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppPhotot.profileLogo,
                    width: 20,
                    height: 20,
                    color: state == 1 ? Constants.mainColor : Constants.thirdColor,
                  ),
                  label: 'الحساب',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    AppPhotot.bookingLogo,
                    width: 18,
                    height: 20,
                    color: state == 2 ? Constants.mainColor : Constants.thirdColor,
                  ),
                  label: 'الحجوزات',
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}