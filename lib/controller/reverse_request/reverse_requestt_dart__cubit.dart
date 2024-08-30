import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import '../../repostry/staduim_repostry.dart';

part 'reverse_requestt_dart__state.dart';

class ReverseRequestCubit extends Cubit<ReverseRequestState> {
  final StadiumRepository stadiumRepository;

  ReverseRequestCubit(this.stadiumRepository) : super(ReverseRequestInitial());

  void sendReverseRequest(int stadiumId, String date, int sessionId, bool isMonthlyReservation, int paymentType) async {
    try {
      emit(ReverseRequestLoading());
      // Make sure the data is formatted correctly
      final requestData = {
        "session": {
          "date": date,
          "session_id": sessionId,
        },
        "stadium_id": stadiumId,
        "is_monthly_reservation": isMonthlyReservation,
        "payment_type": paymentType
      };

      // Send the request
      await stadiumRepository.sendReverseRequest(requestData);

      emit(ReverseRequestSuccess());
    } catch (e) {
      print('Exception: $e');
      emit(ReverseRequestError(e.toString()));
    }
  }
}
