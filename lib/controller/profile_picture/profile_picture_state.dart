part of 'profile_picture_cubit.dart';


abstract class ProfilePictureState extends Equatable {
  const ProfilePictureState();

  @override
  List<Object> get props => [];
}

class ProfilePictureInitial extends ProfilePictureState {}

class ProfilePictureSelected extends ProfilePictureState {
  final String imagePath;

  const ProfilePictureSelected(this.imagePath);

  @override
  List<Object> get props => [imagePath];
}

class ProfilePictureUploaded extends ProfilePictureState {}

class ProfilePictureError extends ProfilePictureState {
  final String message;

  const ProfilePictureError(this.message);

  @override
  List<Object> get props => [message];
}