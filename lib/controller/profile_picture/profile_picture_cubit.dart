import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_picture_state.dart';


class ProfilePictureCubit extends Cubit<ProfilePictureState> {
  final ImagePicker _picker = ImagePicker();

  ProfilePictureCubit() : super(ProfilePictureInitial());

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      emit(ProfilePictureSelected(pickedFile.path));
    } else {
      emit(ProfilePictureError("No image selected"));
    }
  }

  Future<void> uploadImage(String imagePath) async {
    // Implement your upload logic here
    // On success:
    emit(ProfilePictureUploaded());
    // On failure:
    // emit(ProfilePictureError("Failed to upload image"));
  }
}