part of 'fetch_profile_cubit.dart';

@immutable
abstract class FetchProfileState {}

class FetchProfileInitial extends FetchProfileState {}

class FetchProfileLoading extends FetchProfileState {}

class FetchProfileLoaded extends FetchProfileState {
  final User userInfo;

  FetchProfileLoaded(this.userInfo);
}

class FetchProfileEmpty extends FetchProfileState {}

class ProfileSocketExceptionError extends FetchProfileState {}

class FetchProfileError extends FetchProfileState {
  final String message;

  FetchProfileError(this.message);
}


class SignUpStatusLoaded extends FetchProfileState {
  final bool isSignedUp;

  SignUpStatusLoaded(this.isSignedUp);
}