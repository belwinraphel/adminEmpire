 
import 'package:empire/core/services/weather_service.dart';
import 'package:empire/feature/dashboard/domain/entities/climate.dart';
import 'package:empire/feature/dashboard/domain/entities/employee.dart';
import 'package:empire/feature/dashboard/domain/entities/kpi.dart';
import 'package:equatable/equatable.dart';

 
import 'package:flutter/material.dart'; // import for ThemeMode

enum DashboardView { overview, addProduct }

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<KPI> stats;
  final List<Employee> employees;
  final Climate climate;
  final WeatherCondition weatherCondition;
  final DashboardView currentView;
  final ThemeMode themeMode;

  const DashboardLoaded({
    required this.stats,
    required this.employees,
    required this.climate,
    required this.weatherCondition,
    this.currentView = DashboardView.overview,
    this.themeMode = ThemeMode.light,
  });

  @override
  List<Object?> get props => [
    stats,
    employees,
    climate,
    weatherCondition,
    currentView,
    themeMode,
  ];

  DashboardLoaded copyWith({
    List<KPI>? stats,
    List<Employee>? employees,
    Climate? climate,
    WeatherCondition? weatherCondition,
    DashboardView? currentView,
    ThemeMode? themeMode,
  }) {
    return DashboardLoaded(
      stats: stats ?? this.stats,
      employees: employees ?? this.employees,
      climate: climate ?? this.climate,
      weatherCondition: weatherCondition ?? this.weatherCondition,
      currentView: currentView ?? this.currentView,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}
