import 'package:bloc/bloc.dart';

class CheckboxCubit extends Cubit<bool> {
  CheckboxCubit() : super(false);

  void toggle() => emit(!state);
}