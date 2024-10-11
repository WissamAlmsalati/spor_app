import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
import '../../controller/Reservation_fetch/reservation_fetch_state.dart';
import '../../models/reservation.dart';
import '../../utilits/responsive.dart';
import 'widget/current_book_widget.dart';

class CurrentBooking extends StatefulWidget {
  const CurrentBooking({super.key});

  @override
  _CurrentBookingState createState() => _CurrentBookingState();
}

class _CurrentBookingState extends State<CurrentBooking> with AutomaticKeepAliveClientMixin {
  final PagingController<int, Reservation> _pagingController = PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      context.read<ReservationCubit>().fetchReservations(pageKey: pageKey);
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
      body: BlocListener<ReservationCubit, ReservationState>(
        listener: (context, state) {
          if (state is ReservationLoaded) {
            final isLastPage = state.isLastPage;
            if (isLastPage) {
              _pagingController.appendLastPage(state.reservations);
            } else {
              final nextPageKey = _pagingController.nextPageKey! + 1;
              _pagingController.appendPage(state.reservations, nextPageKey);
            }
          } else if (state is ReservationError) {
            _pagingController.error = state.message;
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            _pagingController.refresh();
            context.read<ReservationCubit>().fetchReservations(pageKey: 1);
          },
          child: PagedListView<int, Reservation>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Reservation>(
              itemBuilder: (context, item, index) => CurrentBookWidget(reservation: item),
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
        ),
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
