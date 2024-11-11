import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/controller/Reservation_fetch/reservation_fetch_state.dart';
import 'package:sport/views/auth/widgets/coustom_button.dart';
import '../../controller/Reservation_fetch/reservation_fetch_cubit.dart';
import '../../controller/cancel_reservation/cancekl_reserv_cubit.dart';
import '../../models/reservation.dart';
import 'widget/current_book_widget.dart';

class CurrentBooking extends StatefulWidget {
  const CurrentBooking({super.key});

  @override
  _CurrentBookingState createState() => _CurrentBookingState();
}

class _CurrentBookingState extends State<CurrentBooking>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = 10; // Define page size
  final PagingController<int, Reservation> _pagingController =
      PagingController(firstPageKey: 1); // Start with page 1

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey); // Fetch a new page when requested
    });

    // Listen for cancellation success to refresh the list
    context.read<CanceklReservCubit>().stream.listen((state) {
      if (state is CanceklReservSuccess) {
        _refresh();
      }
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Fetch reservations from the Cubit
      final reservations = await context
          .read<ReservationCubit>()
          .fetchReservations(pageKey: pageKey);

      // Determine if this is the last page
      final isLastPage = reservations.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(reservations);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(reservations, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  Future<void> _refresh() async {
    _pagingController.refresh(); // Reload data from the first page
  }

  @override
  void dispose() {
    _pagingController.dispose(); // Dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    return BlocBuilder<ReservationCubit, ReservationState>(
      builder: (BuildContext context, ReservationState state) {
        if (state is ReservationLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ReservationEmpty) {
          return const Center(child: Text('No reservations found'));
        } else if (state is ReservationError) {
          return Center(
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
        } else if (state is ReservationSocketExaption) {
          return const Center(child: Text('حدث خطأ في الاتصال بالانترنت'));
        }
        return RefreshIndicator(
          onRefresh: _refresh, // Handle pull-to-refresh
          child: PagedListView<int, Reservation>(
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<Reservation>(
              itemBuilder: (context, reservation, index) {
                return ReservationWidget(reservation: reservation);
              },
              firstPageErrorIndicatorBuilder: (context) =>
                  const Center(child: Text('حدث خطأ أثناء تحميل الحجوزات')),
              noItemsFoundIndicatorBuilder: (context) =>
                  const Center(child: Text('لا توجد حجوزات')),
              newPageErrorIndicatorBuilder: (context) =>
                  const Center(child: Text('حدث خطأ')),
              newPageProgressIndicatorBuilder: (context) => const Center(
                  child:
                      ShimmerCurrentBookWidget()), // Replace default loading indicator here
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true; // Keep the state alive
}

class ReservationWidget extends StatelessWidget {
  final Reservation reservation;

  const ReservationWidget({super.key, required this.reservation});

  @override
  Widget build(BuildContext context) {
    return CurrentBookWidget(
        reservation: reservation); // Display reservation details
  }
}
