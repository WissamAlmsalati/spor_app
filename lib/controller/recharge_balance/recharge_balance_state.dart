part of 'recharge_balance_cubit.dart';

abstract class RechargeState {
  const RechargeState();
}

class RechargeInitial extends RechargeState {}

class RechargeLoading extends RechargeState {}

class RechargeSuccess extends RechargeState {
  final Map<String, dynamic> data;

  const RechargeSuccess(this.data);
}

class RechargeEmpty extends RechargeState {}

class RechargeSocketExceptionError extends RechargeState {}

class CloseRechargeDialog extends RechargeState {}

class RechargeFailure extends RechargeState {
  final String error;

  const RechargeFailure(this.error);
}