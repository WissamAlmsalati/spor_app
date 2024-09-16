part of 'cancekl_reserv_cubit.dart';

@immutable
sealed class CanceklReservState {}

final class CanceklReservInitial extends CanceklReservState {}

final class CanceklReservLoading extends CanceklReservState {}

final class CanceklReservSuccess extends CanceklReservState {}

final class CanceklReservFailure extends CanceklReservState {
  final String error;

  CanceklReservFailure(this.error);
}