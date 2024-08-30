import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../../app/theme_data.dart';

class ThemeCubit extends Cubit<ThemeData> {
  ThemeCubit(BuildContext context) : super(CustomThemeData.getThemeData(context));

  void toggleTheme(BuildContext context, bool isDark) {
    emit(isDark ? CustomThemeData.getDarkThemeData(context) : CustomThemeData.getThemeData(context));
  }
}