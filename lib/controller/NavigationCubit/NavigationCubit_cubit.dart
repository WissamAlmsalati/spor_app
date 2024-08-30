import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void updateIndex(int index, BuildContext context) async {
    try {
        emit(index);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
