import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/utilits/constants.dart';
import 'package:sport/utilits/images.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../../../controller/review_comment_controller/comment_review_cubit.dart';
import '../../../models/reservation.dart';
import '../../auth/widgets/coustom_button.dart';
import '../../auth/widgets/coustom_text_field.dart';
import '../../profile/widget/coustom_dialog.dart';
import '../../search_screen/staduim_screen.dart';

class HistoryBookingWidget extends StatelessWidget {
  final Reservation reservation;

  const HistoryBookingWidget({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    final endTime = DateFormat('HH:mm')
        .format(DateFormat('HH:mm:ss').parse(reservation.endTime));
    final startTime = DateFormat('HH:mm')
        .format(DateFormat('HH:mm:ss').parse(reservation.startTime));
    initializeDateFormatting('ar', null);

    DateTime date = DateTime.parse(reservation.date);
    String formattedDate = DateFormat('EEEE', 'ar').format(date);

    return Card(
      margin: EdgeInsets.all(Responsive.screenWidth(context) * 0.03),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.only(
          top: Responsive.screenHeight(context) * 0.02,
          left: Responsive.screenWidth(context) * 0.05,
          right: Responsive.screenWidth(context) * 0.05,
          bottom: Responsive.screenHeight(context) * 0.02,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              reservation.stadiumName,
              style: TextStyle(
                  fontSize: Responsive.textSize(context, 20),
                  fontWeight: FontWeight.w700),
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
                  SizedBox(
                    width: Responsive.screenWidth(context) * 0.02,
                  ),
                  Text(
                    reservation.stadiumAddress,
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 18),
                        fontWeight: FontWeight.w500,
                        color: Constants.txtColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "يوم الحجز: ",
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 16),
                        fontWeight: FontWeight.w500,
                        color: Constants.txtColor),
                  ),
                  Text(
                    formattedDate,
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 18),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
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
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "ساعة الحجز: ",
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 18),
                        fontWeight: FontWeight.w500,
                        color: Constants.txtColor),
                  ),
                  Text(
                    startTime,
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 18),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
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
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.05,
              width: Responsive.screenWidth(context) * 0.35,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "حالة الحجز : ",
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 16),
                        fontWeight: FontWeight.w500,
                        color: Constants.txtColor),
                  ),
                  Text(
                    "منتهي",
                    style: TextStyle(
                        fontSize: Responsive.textSize(context, 18),
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Responsive.screenHeight(context) * 0.054,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomButton(
                    onPress: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>StadiumDetailScreen(stadiumId: reservation.stadiumId,)));
                    },
                    text: 'اعادة الحجز',
                    color: Constants.mainColor,
                    textColor: Colors.white,
                    height: Responsive.screenHeight(context) * 0.05,
                    width: Responsive.screenWidth(context) * 0.4,
                    textSize: Responsive.textSize(context, 12),
                    fontWeight: FontWeight.w700,
                  ),
                  BlocListener<FetchProfileCubit, FetchProfileState>(
                    listener: (context, state) {
                      if (state is FetchProfileLoaded) {
                        print("Profile Data: ${state.userInfo.id}");
                      }
                    },
                    child: BlocListener<StadiumDetailCubit, StaduimDetailState>(
                      listener: (BuildContext context, StaduimDetailState state) {
                        if (state is StaduimDetailLoaded) {
                          print("Stadium Data: ${state.stadiumInfo.id}");
                        }
                      },
                      child: CustomButton(
                        onPress: () {
                          final playerId = (context.read<FetchProfileCubit>().state as FetchProfileLoaded).userInfo.id;
                          showDialog(
                            context: context,
                            builder: (context) => CommentReviewDialog(
                              stadiumId: reservation.stadiumId,
                              playerId: playerId,
                            ),
                          );
                          context.read<FetchProfileCubit>().fetchProfileInfo();
                          print("staduim ID: ${reservation.stadiumId}");
                        },
                        text: 'تقييم الملعب',
                        color: Colors.white,
                        textColor: Constants.mainColor,
                        hasBorder: true,
                        borderColor: Constants.mainColor,
                        height: Responsive.screenHeight(context) * 0.05,
                        width: Responsive.screenWidth(context) * 0.4,
                        textSize: Responsive.textSize(context, 12),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CommentReviewDialog extends StatefulWidget {
  final int stadiumId;
  final int playerId;

  const CommentReviewDialog({Key? key, required this.stadiumId, required this.playerId}) : super(key: key);

  @override
  _CommentReviewDialogState createState() => _CommentReviewDialogState();
}

class _CommentReviewDialogState extends State<CommentReviewDialog> {
  final TextEditingController commentController = TextEditingController();
  double rating = 0.0;

  void _showCommentDialog(BuildContext context, String message) {
    Navigator.of(context).pop(); // Close the current dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return HandleCommentDialog(
          title: 'Comment Posted',
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: Responsive.screenHeight(context) * 0.08, // Adjust height as needed
                child: Lottie.asset('assets/lottifies/Animation - 1725636111104.json'),
              ),
               SizedBox(height: Responsive.screenHeight(context) * 0.02),
              Text(message), // Display the message
            ],
          ),
          canceText: 'Cancel',
          confirmText: 'اغلق',
          onConfirm: () {
            Navigator.of(context).pop(); // Close the dialog on confirmation
          },
          height: Responsive.screenHeight(context) * 0.25, // Adjust height as needed
          width: Responsive.screenWidth(context) * 0.7, // Adjust width as needed
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CommentReviewCubit, CommentReviewState>(
      listener: (context, state) {
        if (state is CommentReviewSuccess) {
          _showCommentDialog(context, 'تم نشر مراجعتك'); // Show success animation dialog
        } else if (state is CommentReviewError) {
          _showCommentDialog(context, state.message); // Show error message dialog
        }
      },
      child: AlertDialog(
        title:  Center(
          child: Text('اضف مراجعتك',style: TextStyle(
            fontSize: 20,

            fontFamily: GoogleFonts.cairo().fontFamily,
            fontWeight: FontWeight.bold,
            color: Constants.mainColor,
          ),),
        ),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: commentController,
              labeltext: 'تعليق',
              lableSize: Responsive.textSize(context, 12),
              hintSize: Responsive.textSize(context, 12),
              validatorText: 'الرجاء ادخال تعليق',
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16),
            RatingBar.builder(
              initialRating: rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) =>  Icon(
                Icons.star,
                color: Constants.mainColor,
              ),
              onRatingUpdate: (newRating) {
                setState(() {
                  rating = newRating;
                });
              },
              glow: false,
            ),
          ],
        ),
        actions: [
          CustomButton(
            onPress: () {
              Navigator.of(context).pop();
            },
            text: 'الغاء',
            hasBorder: true,
            borderColor: Constants.mainColor,
            color: Colors.white,
            textColor: Constants.mainColor,
            textSize: Responsive.textSize(context, 12.5),
            height: Responsive.screenHeight(context) * 0.05,
            width: Responsive.screenWidth(context) * 0.33,

          ),
          CustomButton(
            onPress: () {
              String comment = commentController.text;

              if (comment.isNotEmpty || rating != 0) {
                context.read<CommentReviewCubit>().sendCommentReview(
                  stadiumId: widget.stadiumId,
                  playerId: widget.playerId,
                  comment: comment,
                  rating: rating,
                  context: context,
                );
              }
            },
            text:  'تعليق',
            color: Constants.mainColor,
            textColor: Colors.white,
            textSize: Responsive.textSize(context, 12.5),
            height: Responsive.screenHeight(context) * 0.05,
            width: Responsive.screenWidth(context) * 0.33,


          ),
        ],
      ),
    );
  }
}

class HandleCommentDialog extends StatelessWidget {
  final String title;
  final Widget content; // Content can now be a widget
  final String canceText;
  final String? confirmText;
  final Color? color;
  final Color? borderColor;
  final Color? textColor;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final double? height;
  final double? width;

  const HandleCommentDialog({
    super.key,
    required this.title,
    required this.content,
    required this.canceText,
    this.confirmText,
    this.onConfirm,
    this.onCancel,
    this.color,
    this.borderColor,
    this.textColor,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        height: height ?? Responsive.screenHeight(context) * 0.21,
        width: width ?? Responsive.screenWidth(context) * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            content, // Use the widget directly here
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (confirmText != null)
                  CustomButton(
                    text: confirmText!,
                    onPress: onConfirm,
                    textSize: Responsive.textSize(context, 12.5),
                    color: color ?? Constants.mainColor,
                    textColor: textColor ?? Colors.white,
                    borderColor: borderColor,
                    height: Responsive.screenHeight(context) * 0.05,
                    hasBorder: false,
                    width: confirmText != null ? Responsive.screenWidth(context) * 0.33 : Responsive.screenWidth(context) * 0.66,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}