 
import 'package:empire/core/services/weather_service.dart';
import 'package:empire/core/usecases/usecase.dart';
import 'package:empire/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:flutter/material.dart'; // For ThemeMode
import 'package:flutter_bloc/flutter_bloc.dart';
 

import '../../domain/entities/climate.dart';
import '../../domain/usecases/get_dashboard_stats.dart';
import '../../domain/usecases/get_employees.dart';
import '../../domain/usecases/get_climate_data.dart';

import 'dashboard_event.dart';
export 'dashboard_event.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardStats getDashboardStats;
  final GetEmployees getEmployees;
  final GetClimateData getClimateData;
  final WeatherService weatherService;

  DashboardBloc({
    required this.getDashboardStats,
    required this.getEmployees,
    required this.getClimateData,
    required this.weatherService,
  }) : super(DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardViewChanged>(_onViewChanged);
    on<DashboardThemeToggled>(_onThemeToggled);
  }

  void _onViewChanged(
    DashboardViewChanged event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(currentView: event.view));
    }
  }

  void _onThemeToggled(
    DashboardThemeToggled event,
    Emitter<DashboardState> emit,
  ) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      final newMode = currentState.themeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
      emit(currentState.copyWith(themeMode: newMode));
    }
  }

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    final statsResult = await getDashboardStats(NoParams());
    final employeesResult = await getEmployees(NoParams());
    final climateResult = await getClimateData(NoParams());
    final weatherCondition = await weatherService.getWeatherCondition();

    statsResult.fold(
      (failure) => emit(const DashboardError(message: 'Failed to load stats')),
      (stats) {
        employeesResult.fold(
          (failure) =>
              emit(const DashboardError(message: 'Failed to load employees')),
          (employees) {
            climateResult.fold(
              (failure) {
                emit(
                  DashboardLoaded(
                    stats: stats,
                    employees: employees,
                    climate: const Climate(
                      temperature: 25.0,
                      windSpeed: 0,
                      humidity: 0,
                      condition: 'Unknown',
                      videoUrl:
                          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
                    ),
                    weatherCondition: weatherCondition, // Use fetched
                  ),
                );
              },
              (climate) => emit(
                DashboardLoaded(
                  stats: stats,
                  employees: employees,
                  climate: climate,
                  weatherCondition: weatherCondition,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
