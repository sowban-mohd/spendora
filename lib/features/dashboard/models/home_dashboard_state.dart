enum DashboardWindow { week, month }

class HomeDashboardState {
  final DashboardWindow selectedWindow;

  const HomeDashboardState({required this.selectedWindow});

  HomeDashboardState copyWith({DashboardWindow? selectedWindow}) {
    return HomeDashboardState(
      selectedWindow: selectedWindow ?? this.selectedWindow,
    );
  }
}