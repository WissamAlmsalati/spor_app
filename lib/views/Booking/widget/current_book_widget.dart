import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/utilits/loading_animation.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/models/reservation.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:sport/views/profile/widget/coustom_dialog.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
        return CustomAlertDialog(
          title: "الغاء الحجز",
          content: "هل انت متأكد من الغاء الحجز",
          canceText: "الغاء",
          confirmText: "تأكيد",
          onConfirm: () {
            context.read<CanceklReservCubit>().cancelReservation(
                widget.reservation.id.toString(), context);
            context.read<ReservationCubit>().fetchReservations();
            Navigator.of(context).pop();
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
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

    return BlocListener<CanceklReservCubit, CanceklReservState>(
      listener: (context, state) {
        if (state is CanceklReservSuccess) {
          context.read<ReservationCubit>().fetchReservations();
          CustomToast.show(context, 'تم الغاء الحجز بنجاح');
        } else if (state is CanceklReservFailure) {
          CustomToast.show(context, 'حدث خطأ اثناء الغاء الحجز');
        }
      },
      child: Card(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.reservation.stadiumName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (canDelete)
                    BlocBuilder<CanceklReservCubit, CanceklReservState>(
                      builder: (BuildContext context, CanceklReservState state) {
                        if (state is CanceklReservLoading) {
                          return LoadingAnimation(size: MediaQuery.sizeOf(context).height * 0.02);
                        }

                        return IconButton(
                          icon: const Icon(
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
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.black.withOpacity(0.5),
                        fontWeight: FontWeight.w600,
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
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) {
                        //           return TimerScreen(
                        //               selectedTime: startDateTime);
                        //         },
                        //       ),
                        //     );
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

class CustomToast {
  static void show(BuildContext context, String message) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => _ToastWidget(message: message),
    );

    Overlay.of(context).insert(overlayEntry);

    Timer(const Duration(seconds: 2), () {
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
      duration: const Duration(milliseconds: 300),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: Constants.mainColor,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(
                Responsive.screenWidth(context) * 0.03),
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


class ShimmerCurrentBookWidget extends StatelessWidget {
  const ShimmerCurrentBookWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: Responsive.screenHeight(context) * 0.02,
                    width: Responsive.screenWidth(context) * 0.4,
                    color: Colors.white,
                  ),
                  Container(
                    height: Responsive.screenHeight(context) * 0.02,
                    width: Responsive.screenWidth(context) * 0.1,
                    color: Colors.white,
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: Responsive.screenHeight(context) * 0.013),
                child: Row(
                  children: [
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.1,
                      color: Colors.white,
                    ),
                    SizedBox(width: Responsive.screenWidth(context) * 0.02),
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.5,
                      color: Colors.white,
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
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.2,
                      color: Colors.white,
                    ),
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.2,
                      color: Colors.white,
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
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.2,
                      color: Colors.white,
                    ),
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.2,
                      color: Colors.white,
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
                    Container(
                      height: Responsive.screenHeight(context) * 0.05,
                      width: Responsive.screenWidth(context) * 0.4,
                      color: Colors.white,
                    ),
                    Container(
                      height: Responsive.screenHeight(context) * 0.05,
                      width: Responsive.screenWidth(context) * 0.4,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}