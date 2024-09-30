import 'package:sport/views/search_screen/widget/session_list.dart';
import 'package:sport/views/search_screen/widget/staduim_rating.dart';
import 'package:sport/views/stadium/screens/widget/comments_widget.dart';
import '../../../app/app_packges.dart';
import '../../../controller/staduim_detail_creen_cubit/staduim_detail_cubit.dart';
import 'HorizontalCalendar.dart';

class StadiumDetailBody extends StatelessWidget {
  final stadium;
  final List sessions;
  final selectedSession;
  final StadiumDetailCubit cubit;

  const StadiumDetailBody({
    super.key,
    required this.stadium,
    required this.sessions,
    required this.selectedSession,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // Wrap with SingleChildScrollView for unified scrolling
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              height: Responsive.screenHeight(context) * 0.05,
              child: Center(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(stadium.name,
                        style: TextStyle(
                            fontSize: Responsive.textSize(context, 18),
                            fontWeight: FontWeight.bold)),
                  ))),
          Row(
            children: [
              SvgPicture.asset(AppPhotot.locationIco),
              SizedBox(width: Responsive.screenWidth(context) * 0.02),
              Text(stadium.address,
                  style: TextStyle(fontSize: Responsive.textSize(context, 14))),
            ],
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          StadiumInfoSummary(
            totalReservations: stadium.totalReservations,
            avgReviews: stadium.avgReviews,
            totalReviews: stadium.totalReviews,
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("اختيار اليوم",
                  style: TextStyle(
                      fontSize: Responsive.textSize(context, 16),
                      fontWeight: FontWeight.w600)),
              Row(
                children: [
                  Text("حجز شهري",
                      style: TextStyle(
                          fontSize: Responsive.textSize(context, 10),
                          fontWeight: FontWeight.w600,
                          color: Constants.txtColor)),
                  BlocBuilder<CheckboxCubit, bool>(
                    builder: (context, isChecked) {
                      return Checkbox(
                        checkColor: Colors.white,
                        activeColor: Constants.mainColor,
                        value: isChecked,
                        onChanged: (value) {
                          context.read<CheckboxCubit>().toggle();
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          sessions.isNotEmpty
              ? DateSelector(
                  dates: sessions
                      .map((session) => session.date as String)
                      .toList(),
                  selectedDate: cubit.selectedDate,
                  onDateSelected: (date) {
                    cubit.setSelectedDate(date);
                  },
                )
              : const Center(child: Text('No available dates')),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Text("اختيار التوقيت",
              style: TextStyle(
                  fontSize: Responsive.textSize(context, 16),
                  fontWeight: FontWeight.w600)),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          selectedSession != null
              ? SessionList(
                  availableSession: selectedSession,
                  selectedSessionId: cubit.selectedSessionId ?? 0,
                  onTimeSelected: (sessionId, time) {
                    cubit.setSelectedSessionId(sessionId, time);
                  },
                )
              : const Center(child: Text('No available times')),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("التعليقات",
                  style: TextStyle(
                      fontSize: Responsive.textSize(context, 16),
                      fontWeight: FontWeight.w600)),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => AllCommentsScreen(stadiumId: stadium.id)));
              }, child: Text("عرض الكل",style: TextStyle(
                  fontSize: Responsive.textSize(context, 12),
                  color: Constants.mainColor,
                  fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.cairo().fontFamily
              ),)),
            ],
          ),
          SizedBox(height: Responsive.screenHeight(context) * 0.02),
          SizedBox(
            height: Responsive.screenHeight(context) * 0.5,
            child: BlocProvider(
              create: (context) => FetchCommentsCubit(),

              child: CommentsWidget(
                  isScrollable: false,
                  stadiumId: stadium.id),
            )),
        ],
      ),
    );
  }
}

class AllCommentsScreen extends StatelessWidget {
  final int stadiumId;
  const AllCommentsScreen({super.key, required this.stadiumId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التعليقات",style: TextStyle(
            fontSize: Responsive.textSize(context, 16),
            fontWeight: FontWeight.w600,
            fontFamily: GoogleFonts.cairo().fontFamily
        ),),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Responsive.screenWidth(context) * 0.04),
        child: CommentsWidget(stadiumId: stadiumId,isScrollable: true),
      ),
    );
  }
}