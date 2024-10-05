import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sport/controller/old_reveresition/old_reservation_fetch_cubit.dart';
import 'package:sport/utilits/responsive.dart';
import 'package:sport/views/Booking/widget/history_booking_widget.dart';
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
      context.read<OldReservationFetchCubit>().fetchOldReservations(pageKey: pageKey);
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
            return const ShimmerLoadingWidget();
          } else if (state is UnAuthenticated) {
            return const Center(child: Text('يجب تسجيل الدخول اولا'));
          } else if (state is OldReservationLoaded) {
            final isLastPage = state.isLastPage;
            if (isLastPage) {
              _pagingController.appendLastPage(state.reservations);
            } else {
              final nextPageKey = _pagingController.nextPageKey! + 1;
              _pagingController.appendPage(state.reservations, nextPageKey);
            }
          } else if (state is OldReservationError) {
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
                firstPageProgressIndicatorBuilder: (context) => const ShimmerLoadingWidget(),
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

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: Responsive.screenHeight(context) * 0.3,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.6,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: Responsive.screenHeight(context) * 0.02,
                      width: Responsive.screenWidth(context) * 0.4,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      height: Responsive.screenHeight(context) * 0.05,
                      width: Responsive.screenWidth(context) * 0.3,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}