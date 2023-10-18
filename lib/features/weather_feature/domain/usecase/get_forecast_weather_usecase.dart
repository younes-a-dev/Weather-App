import 'package:weather_app/core/params/forecast_params.dart';
import 'package:weather_app/core/usecase/usecase.dart';
import 'package:weather_app/features/weather_feature/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/features/weather_feature/domain/repository/weather_repository.dart';

import '../../../../core/resources/data_state.dart';

class GetForecastWeatherUsecase implements UseCase<DataState<ForecastDaysEntity>, ForecastParams> {
  final WeatherRepository _weatherRepository;

  GetForecastWeatherUsecase(this._weatherRepository);

  @override
  Future<DataState<ForecastDaysEntity>> call(ForecastParams params) {
    return _weatherRepository.fetchForecastWeatherData(params);
  }
}
