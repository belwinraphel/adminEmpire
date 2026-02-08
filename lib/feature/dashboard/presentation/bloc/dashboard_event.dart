import 'package:equatable/equatable.dart';
import 'dashboard_state.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class DashboardStarted extends DashboardEvent {}

class DashboardViewChanged extends DashboardEvent {
  final DashboardView view;

  const DashboardViewChanged(this.view);

  @override
  List<Object> get props => [view];
}

class DashboardThemeToggled extends DashboardEvent {}
