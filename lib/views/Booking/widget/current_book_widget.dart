import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:sport/app/app_cubits.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/models/reservation.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/cancel_reservation/cancekl_reserv_cubit.dart';
import '../../auth/widgets/coustom_button.dart';
import 'package:percent_indicator/percent_indicator.dart';


class CurrentBookWidget extends StatefulWidget {
  final Reservation reservation;

  const CurrentBookWidget({super.key, required this.reservation});

  @override
  _CurrentBookWidgetState createState() => _CurrentBookWidgetState();
}

class _CurrentBookWidgetState extends State<CurrentBookWidget> {
  late Timer _timer;
  bool canDelete = true;

  @override
  void initState() {
    super.initState();
    _checkTime();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkTime();
    });
  }

  void _checkTime() {
    setState(() {
      canDelete = DateTime.now().difference(widget.reservation.timestamp).inMinutes <= 5;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _launchGoogleMaps(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancellation'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to cancel this reservation?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirm'),
              onPressed: () {
                try {
                  context.read<CanceklReservCubit>().cancelReservation(widget.reservation.id.toString());
                  RefreshCubit.refreshCubits(context);
                  Navigator.of(context).pop();

                } catch (e) {
                  print(e);
                }

              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final endTime = DateFormat('HH:mm')
        .format(DateFormat('HH:mm:ss').parse(widget.reservation.endTime));
    final startTime = DateFormat('HH:mm')
        .format(DateFormat('HH:mm:ss').parse(widget.reservation.startTime));
    initializeDateFormatting('ar', null);

    DateTime date = DateTime.parse(widget.reservation.date);
    String formattedDate = DateFormat('EEEE', 'ar').format(date);

    final startDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      DateFormat('HH:mm:ss').parse(widget.reservation.startTime).hour,
      DateFormat('HH:mm:ss').parse(widget.reservation.startTime).minute,
      DateFormat('HH:mm:ss').parse(widget.reservation.startTime).second,
    );

    bool isMatchStarted = DateTime.now().isAfter(startDateTime);

    return Card(
      margin: EdgeInsets.all(Responsive.screenWidth(context) * 0.03),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.only(
          top: Responsive.screenHeight(context) * 0.02,
          left: Responsive.screenWidth(context) * 0.05,
          right: Responsive.screenWidth(context) * 0.05,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.reservation.stadiumName,
                  style: TextStyle(
                    fontSize: Responsive.textSize(context, 20),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (canDelete)
                  BlocBuilder<CanceklReservCubit, CanceklReservState>(
                    builder: (BuildContext context, CanceklReservState state) {
                      return IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          try {
                            _showConfirmationDialog(context);
                          } catch (e) {
                            print(e);
                          }
                        },
                      );
                    },
                  ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: Responsive.screenHeight(context) * 0.013),
              child: Row(
                children: [
                  SvgPicture.asset(
                    AppPhotot.locationIco,
                    color: Colors.green,
                    fit: BoxFit.fill,
                  ),
                  SizedBox(width: Responsive.screenWidth(context) * 0.02),
                  Text(
                    widget.reservation.stadiumAddress,
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 18),
                      fontWeight: FontWeight.w500,
                      color: Constants.txtColor,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "يوم الحجز: ",
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 16),
                      fontWeight: FontWeight.w500,
                      color: Constants.txtColor,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 18),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: Responsive.screenHeight(context) * 0.005,
                    width: Responsive.screenWidth(context) * 0.04,
                    decoration: BoxDecoration(
                      color: Constants.txtColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 18),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ساعة الحجز: ",
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 16),
                      fontWeight: FontWeight.w500,
                      color: Constants.txtColor,
                    ),
                  ),
                  Text(
                    startTime,
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 18),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    height: Responsive.screenHeight(context) * 0.005,
                    width: Responsive.screenWidth(context) * 0.04,
                    decoration: BoxDecoration(
                      color: Constants.txtColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  Text(
                    endTime,
                    style: TextStyle(
                      fontSize: Responsive.textSize(context, 18),
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.09,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomButton(
                    onPress: () async {
                      _launchGoogleMaps(widget.reservation.mapUrl);
                    },
                    text: 'مكان الملعب',
                    color: Constants.mainColor,
                    textColor: Colors.white,
                    height: Responsive.screenHeight(context) * 0.05,
                    width: Responsive.screenWidth(context) * 0.4,
                    textSize: Responsive.textSize(context, 12),
                    fontWeight: FontWeight.w700,
                  ),
                  CustomButton(
                    onPress: isMatchStarted
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return TimerScreen(
                                selectedTime: startDateTime);
                          },
                        ),
                      );
                    }
                        : () {
                      CustomToast.show(
                        context,
                        _getFormattedDurationText(
                            startDateTime.difference(DateTime.now())),
                      );
                    },
                    text: isMatchStarted ? 'المبارة بدأت' : 'الوقت المتبقي',
                    color: Colors.transparent,
                    textColor: isMatchStarted ? Colors.red : Constants.mainColor,
                    brWidth: 1.5,
                    height: Responsive.screenHeight(context) * 0.05,
                    width: Responsive.screenWidth(context) * 0.4,
                    hasBorder: true,
                    borderColor: isMatchStarted
                        ? Colors.red
                        : Constants.mainColor,
                    textSize: Responsive.textSize(context, 12),
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getFormattedDurationText(Duration duration) {
    if (duration.inDays > 0) {
      return 'متبقي${duration.inDays} يوم و${duration.inHours.remainder(24)} ساعة';
    } else if (duration.inHours > 0) {
      return 'متبقي${duration.inHours} ساعة و${duration.inMinutes.remainder(60)} دقيقة';
    } else {
      return 'متبقي${duration.inMinutes} دقيقة و${duration.inSeconds.remainder(60)} ثانية';
    }
  }
}
class TimerScreen extends StatelessWidget {
  final DateTime selectedTime;

  TimerScreen({required this.selectedTime});

  @override
  Widget build(BuildContext context) {
    // Get the current time
    DateTime now = DateTime.now();

    Duration totalDuration = selectedTime.difference(now);
    Duration timeRemaining = totalDuration;

    double percentRemaining = timeRemaining.inSeconds / totalDuration.inSeconds;

    String formattedTime = _formatDuration(timeRemaining);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timer Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 13.0,
              animation: true,
              percent: percentRemaining.clamp(0.0, 1.0), // Ensure percent is between 0 and 1
              center: Text(
                formattedTime,
                style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              progressColor: Colors.green,
              backgroundColor: Colors.grey[300]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 20),
            Text(
              'Time to reserve: $formattedTime',
              style: const TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int days = duration.inDays;
    int hours = duration.inHours.remainder(24);
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    if (days > 1) {
      return '$days يوم${days > 1 ? "s" : ""} $hours ساعة${hours > 1 ? "s" : ""}';
    } else if (days == 1) {
      return '1 يوم $hours ساعة${hours > 1 ? "s" : ""}';
    } else if (hours > 0) {
      return '$hours ساعة $minutes دقيقة${minutes > 1 ? "s" : ""}';
    } else if (minutes > 0) {
      return '$minutes دقيقة $seconds ثانية${seconds > 1 ? "s" : ""}';
    } else {
      return '$seconds ثانية${seconds > 1 ? "s" : ""}';
    }
  }
}






class CustomToast {
  static void show(BuildContext context, String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: message),
    );

    Overlay.of(context).insert(overlayEntry);

    Timer(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;

  const _ToastWidget({required this.message});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 50.0,
      left: MediaQuery.of(context).size.width * 0.2,
      right: MediaQuery.of(context).size.width * 0.2,
      child: _AnimatedToast(message: message),
    );
  }
}

class _AnimatedToast extends StatelessWidget {
  final String message;

  const _AnimatedToast({required this.message});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Constants.mainColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Responsive.screenWidth(context) * 0.03),

          ),
          child: Text(
            message,
            style: TextStyle(
              color: Colors.white,
              fontSize: Responsive.textSize(context, 9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

// Usage example in your code:

