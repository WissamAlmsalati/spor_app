import 'package:http/http.dart' as http;
import 'package:sport/app/app_packges.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'cancekl_reserv_state.dart';

class CanceklReservCubit extends Cubit<CanceklReservState> {
  final http.Client _client;

  CanceklReservCubit() : _client = HttpInterceptor(http.Client()), super(CanceklReservInitial());

  Future<void> cancelReservation(String reservationId, BuildContext context) async {
    final token = await SecureStorageData.getToken();
    emit(CanceklReservLoading());
    try {
      final response = await _client.post(
        Uri.parse('https://api.sport.com.ly/player/cancel-reservation'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: {'reservation_id': reservationId},
      );

      if (response.statusCode == 200) {
        print('Reservation canceled successfully');
        emit(CanceklReservSuccess());
      } else {
        print('Failed to cancel reservation: ${response.reasonPhrase}');
        emit(CanceklReservFailure('Failed to cancel reservation'));
      }
    } catch (e) {
      print('An error occurred: $e');
      emit(CanceklReservFailure(e.toString()));
    }
  }
}