import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sport/services/apis.dart';
import '../../app/app_cubits.dart';
import '../../utilits/secure_data.dart';
import '../../app/authintication_middleware.dart'; // Import the HttpInterceptor

part 'recharge_balance_state.dart';

class RechargeCubit extends Cubit<RechargeState> {
  final http.Client _client;

  RechargeCubit() : _client = HttpInterceptor(http.Client()), super(RechargeInitial());

  Future<void> rechargeCard(String cardNumber, BuildContext context) async {
    emit(RechargeLoading());
    try {
      final token = await SecureStorageData.getToken();

      final response = await _client.post(
        Uri.parse(Apis.rechargeBalance),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'code': cardNumber,
        },
      );
print('Response status code: ${response.statusCode}');
print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        emit(RechargeSuccess(data));
        RefreshCubit.refreshBalance(context);
      } else if (response.statusCode == 400) {
        emit(RechargeEmpty());
      } else {
        if (kDebugMode) {
          print(response.statusCode);
        }
        emit(const RechargeFailure('Failed to recharge card'));
      }
    } catch (e) {
      if (e is SocketException) {
        emit(RechargeSocketExceptionError());
      } else {
        emit(RechargeFailure(e.toString()));
      }
    }
  }

  void closeDialog(BuildContext context) {
    emit(CloseRechargeDialog());
  }
}