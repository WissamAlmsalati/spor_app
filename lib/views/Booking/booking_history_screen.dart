import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sport/controller/old_reveresition/old_reservation_fetch_cubit.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/Booking/widget/current_book_widget.dart';
import 'package:sport/views/Booking/widget/history_booking_widget.dart';
import '../../controller/old_reveresition/old_reservation_fetch_state.dart';
import '../../models/reservation.dart';
import '../../utilits/constants.dart';
import '../auth/widgets/coustom_button.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  _BookingHistoryScreenState createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> with AutomaticKeepAliveClientMixin {
  final PagingController<int, Reservation> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final reservations = await context.read<OldReservationFetchCubit>().fetchOldReservations(pageKey: pageKey);
      if (reservations.isNotEmpty) {
        _pagingController.appendPage(reservations, pageKey + 1);
      } else {
        _pagingController.appendLastPage(reservations);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: BlocBuilder<OldReservationFetchCubit, OldReservationFetchState>(
        builder: (context, state) {
          if (state is OldReservationLoading) {
            return const ShimmerCurrentBookWidget();
          } else if (state is UnAuthenticatedUser) {
            return  Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("يرجى تسجيل الدخول اولا"),
                    const SizedBox(height: 16.0),
                    CustomButton(
                      onPress: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      text: 'تسجيل الدخول',
                      color: Constants.mainColor,
                      textColor: const Color(0xffFFFFFF),
                      height: Responsive.screenHeight(context) * 0.045,
                      width: MediaQuery.of(context).size.width * 0.3,
                      textSize: Theme.of(context).textTheme.bodySmall!.fontSize,
                    ),
                  ],
                ));
          } else if (state is OldReservationSocketExceptionError) {
            return Center(
              child: Text(
                'حدث خطأ في الاتصال بالانترنت',
                style: TextStyle(fontSize: Responsive.textSize(context, 12)),
              ),
            );
          } else if (state is OldReservationLoaded) {
            final isLastPage = state.isLastPage;
            if (isLastPage) {
              _pagingController.appendLastPage(state.reservations);
            } else {
              _pagingController.appendPage(state.reservations, _pagingController.nextPageKey! + 1);
            }
          } else if (state is OldReservationEmpty) {
            return Center(
              child: Text(
                'لا توجد حجوزات حالية',
                style: TextStyle(fontSize: Responsive.textSize(context, 12)),
              ),
            );
          } else if (state is OldReservationError) {
            _pagingController.error = state.message;
          }

          return RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
              await _fetchPage(1);
            },
            child: PagedListView<int, Reservation>(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Reservation>(
                itemBuilder: (context, item, index) => HistoryBookingWidget(reservation: item),
                firstPageProgressIndicatorBuilder: (context) => const ShimmerCurrentBookWidget(),
                newPageProgressIndicatorBuilder: (context) => const Center(child: CircularProgressIndicator()),
                noMoreItemsIndicatorBuilder: (context) => Center(
                  child: Container(
                    padding: EdgeInsets.only(
                      top: Responsive.screenHeight(context) * 0.01,
                      bottom: Responsive.screenHeight(context) * 0.02,
                    ),
                    child: Text(
                      'لا توجد حجوزات اخرى',
                      style: TextStyle(fontSize: Responsive.textSize(context, 12)),
                    ),
                  ),
                ),
                noItemsFoundIndicatorBuilder: (context) => Center(
                  child: Text(
                    'لا توجد حجوزات حالية',
                    style: TextStyle(fontSize: Responsive.textSize(context, 12)),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}