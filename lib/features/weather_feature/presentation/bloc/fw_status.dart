import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/features/weather_feature/domain/entities/forecast_days_entity.dart';

@immutable
abstract class FwStatus extends Equatable {}

// Loading state
class FwLoading extends FwStatus {
  @override
  List<Object?> get props => [];
}

// Loaded state
class FwCompleted extends FwStatus {
  final ForecastDaysEntity forecastDaysEntity;

  FwCompleted(this.forecastDaysEntity);

  @override
  List<Object?> get props => [forecastDaysEntity];
}


// Error state
class FwError extends FwStatus{
  final String? message;

  FwError(this.message);

  @override
  List<Object?> get props => [message];

}
