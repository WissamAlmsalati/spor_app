part of 'update_profile_cubit.dart';


abstract class UpdateProfileState extends Equatable {
  const UpdateProfileState();

  @override
  List<Object> get props => [];
}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileSuccess extends UpdateProfileState {}

class UpdateProfileError extends UpdateProfileState {
  final String message;

  const UpdateProfileError(this.message);

  @override
  List<Object> get props => [message];
}