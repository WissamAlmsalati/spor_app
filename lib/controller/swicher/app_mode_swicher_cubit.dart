import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


part 'app_mode_swicher_state.dart';

class AppModeSwicherCubit extends Cubit<AppModeSwicherState> {
  AppModeSwicherCubit() : super(AppModeSwicherInitial());

  Future<void> changeToDarkMode() async {
    emit(AppModeSwicherDarkMood());
  }

  Future<void> changeToLightMode() async {
    emit(AppModeSwicherLightMood());
  }

}