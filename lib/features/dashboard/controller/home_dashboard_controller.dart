import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendora/features/dashboard/models/home_dashboard_state.dart';

final homeDashboardControllerProvider =
    NotifierProvider.autoDispose<HomeDashboardController, HomeDashboardState>(
  HomeDashboardController.new,
);

class HomeDashboardController extends Notifier<HomeDashboardState> {
  @override
  HomeDashboardState build() {
    return const HomeDashboardState(selectedWindow: DashboardWindow.week);
  }

  void setWindow(DashboardWindow window) {
    state = state.copyWith(selectedWindow: window);
  }
}
