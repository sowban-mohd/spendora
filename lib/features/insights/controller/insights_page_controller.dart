import 'package:flutter_riverpod/flutter_riverpod.dart';

final insightsPageControllerProvider =
    NotifierProvider.autoDispose<InsightsPageController, InsightsPageState>(
  InsightsPageController.new,
);

class InsightsPageController extends Notifier<InsightsPageState> {
  @override
  InsightsPageState build() {
    return const InsightsPageState(selectedMode: InsightMode.monthly);
  }

  void setMode(InsightMode mode) {
    state = state.copyWith(selectedMode: mode);
  }
}

enum InsightMode { weekly, monthly }

class InsightsPageState {
  final InsightMode selectedMode;

  const InsightsPageState({required this.selectedMode});

  InsightsPageState copyWith({InsightMode? selectedMode}) {
    return InsightsPageState(
      selectedMode: selectedMode ?? this.selectedMode,
    );
  }
}
