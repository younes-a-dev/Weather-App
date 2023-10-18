import 'package:weather_app/core/params/forecast_params.dart';
import 'package:weather_app/features/weather_feature/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/weather_feature/domain/entities/forecast_days_entity.dart';

import '../../../../core/resources/data_state.dart';
import '../../data/models/suggest_city_model.dart';

abstract class WeatherRepository{
 Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName);

 Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams forecastParams);


 // city name = prefix
 Future<List<Data>> fetchSuggestData(cityName);
}