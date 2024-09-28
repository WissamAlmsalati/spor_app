import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sport/app/app_packges.dart';
import 'package:sport/views/profile/widget/coustom_dialog.dart';

part 'profile_picture_state.dart';

class ProfilePictureCubit extends Cubit<ProfilePictureState> {
  final ImagePicker _picker = ImagePicker();

  ProfilePictureCubit() : super(ProfilePictureInitial());

  Future<void> pickImage() async {
    print('Picking image');
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('Image selected: ${pickedFile.path}');
      emit(ProfilePictureSelected(pickedFile.path));
    } else {
      print('No image selected');
      emit(ProfilePictureError("No image selected"));
    }
  }

  Future<void> uploadImage(String imagePath, BuildContext context) async {
    final token = await SecureStorageData
        .getToken(); // Ensure token is retrieved asynchronously
    print('Uploading image');
    final url =
        Uri.parse('https://api.sport.com.ly/player/update-player-image');
    final request = http.MultipartRequest('PATCH', url)
      ..files.add(await http.MultipartFile.fromPath('image', imagePath))
      ..headers['Authorization'] = 'Bearer $token';

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        print('Image uploaded');
        emit(ProfilePictureUploaded());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              borderColor: Constants.mainColor,
              color: Constants.mainColor,
              textColor: Constants.mainColor,
              title: 'نجاح',
              content: 'تم تحديث الصورة الشخصية بنجاح',
              canceText: 'اغلاق',
              onCancel: () => Navigator.of(context).pop(),
            );
          },
        );
      } else {
        print('Failed to upload image: ${responseBody.body}');
        emit(ProfilePictureError(
            "Failed to upload image: ${responseBody.body}"));
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CustomAlertDialog(
              title: 'Error',
              content: 'Failed to upload image: ${responseBody.body}',
              canceText: 'OK',
              onCancel: () => Navigator.of(context).pop(),
            );
          },
        );
      }
    } catch (e) {
      print('Failed to upload image: $e');
      emit(ProfilePictureError("Failed to upload image: $e"));
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomAlertDialog(
            title: 'Error',
            content: 'Failed to upload image: $e',
            canceText: 'OK',
            onCancel: () => Navigator.of(context).pop(),
          );
        },
      );
    }
  }
}
