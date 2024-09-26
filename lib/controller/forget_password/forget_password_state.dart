part of 'forget_password_cubit.dart';

// lib/controller/forget_password/forget_password_state.dart

abstract class ForgetPasswordState extends Equatable {
  const ForgetPasswordState();

  @override
  List<Object> get props => [];
}

class ForgetPasswordInitial extends ForgetPasswordState {}

class ForgetPasswordLoading extends ForgetPasswordState {}

class ForgetPasswordStep1Success extends ForgetPasswordState {}

class ForgetPasswordStep2Success extends ForgetPasswordState {
  final String token;

  const ForgetPasswordStep2Success(this.token);

  @override
  List<Object> get props => [token];
}

class ForgetPasswordStep3Success extends ForgetPasswordState {}

class ForgetPasswordFailure extends ForgetPasswordState {
  final String error;

  const ForgetPasswordFailure(this.error);

  @override
  List<Object> get props => [error];
}