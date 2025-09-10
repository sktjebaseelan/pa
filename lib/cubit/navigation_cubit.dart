import 'package:bloc/bloc.dart';
import 'package:expense_tracker/constant/app_pages.dart';

class NavigationCubit extends Cubit<AppPage> {
  NavigationCubit() : super(AppPage.dashboard);

  void navigateTo(AppPage page) => emit(page);
}
