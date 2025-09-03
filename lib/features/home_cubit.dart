import 'package:flutter_bloc/flutter_bloc.dart';

class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void navigateTo(int index) {
    if (index >= 0 && index < 4) {
      emit(index);
    }
  }

  void navigateToHome() => emit(0);
  void navigateToSearch() => emit(1);
  void navigateToCreate() => emit(2);
  void navigateToProfile() => emit(3);
}
