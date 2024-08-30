import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class OnboardingCubit extends Cubit<int> {
  final SwiperController swiperController = SwiperController();

  OnboardingCubit() : super(0);

  void updatePage(int index) {
    emit(index);
  }

  @override
  Future<void> close() {
    swiperController.dispose();
    return super.close();
  }
}