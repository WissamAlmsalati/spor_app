import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/controller/old_reveresition/old_reservation_fetch_cubit.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/Booking/widget/current_book_widget.dart';
import 'package:sport/views/Booking/widget/history_booking_widget.dart';
import '../../controller/old_reveresition/old_reservation_fetch_state.dart';
import '../../models/reservation.dart';

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
      context.read<OldReservationFetchCubit>().fetchOldReservations(pageKey: pageKey).then((reservations) {
        if (reservations.isNotEmpty) {
          _pagingController.appendPage(reservations, pageKey + 1);
        } else {
          _pagingController.appendLastPage(reservations);
        }
      });
    });
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
            // Show shimmer effect when loading reservations
            return const ShimmerCurrentBookWidget();
          } else if (state is UnAuthenticatedUser) {
            // Show message for unauthenticated users
            return const Center(child: Text('يجب تسجيل الدخول اولا'));
          } else if (state is OldReservationLoaded) {
            // Handle loaded reservations
            final isLastPage = state.isLastPage;
            if (isLastPage) {
              _pagingController.appendLastPage(state.reservations);
            } else {
              _pagingController.appendPage(state.reservations, _pagingController.nextPageKey! + 1);
            }
          } else if (state is OldReservationEmpty) {
            // Show message when no reservations are found
            return Center(
              child: Text(
                'لا توجد حجوزات حالية',
                style: TextStyle(fontSize: Responsive.textSize(context, 12)),
              ),
            );
          } else if (state is OldReservationError) {
            // Handle error state
            _pagingController.error = state.message;
          }

          return RefreshIndicator(
            onRefresh: () async {
              _pagingController.refresh();
              context.read<OldReservationFetchCubit>().fetchOldReservations(pageKey: 1);
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
