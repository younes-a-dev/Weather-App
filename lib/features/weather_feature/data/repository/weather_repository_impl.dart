import 'package:dio/dio.dart';
import 'package:weather_app/core/params/forecast_params.dart';
import 'package:weather_app/core/resources/data_state.dart';
import 'package:weather_app/features/weather_feature/data/data_source/remote/api_provider.dart';
import 'package:weather_app/features/weather_feature/data/models/current_city_model.dart';
import 'package:weather_app/features/weather_feature/data/models/forecast_days_model.dart';
import 'package:weather_app/features/weather_feature/data/models/suggest_city_model.dart';
import 'package:weather_app/features/weather_feature/domain/entities/current_city_entity.dart';
import 'package:weather_app/features/weather_feature/domain/entities/forecast_days_entity.dart';
import 'package:weather_app/features/weather_feature/domain/entities/suggest_city_entity.dart';
import 'package:weather_app/features/weather_feature/domain/repository/weather_repository.dart';

class WeatherRepositoryImpl extends WeatherRepository {
  ApiProvider apiProvider;

  WeatherRepositoryImpl(this.apiProvider);

  @override
  Future<DataState<CurrentCityEntity>> fetchCurrentWeatherData(String cityName) async {
    try {
      Response response = await apiProvider.getCurrentWeather(cityName);
      if (response.statusCode == 200) {
        CurrentCityEntity currentCityEntity = CurrentCityModel.fromJson(response.data);
        return DataSuccess(currentCityEntity);
      } else {
        return const DataFailed("Something went wrong...");
      }
    } catch (e) {
      return const DataFailed("Please check your connection");
    }
  }

  @override
  Future<DataState<ForecastDaysEntity>> fetchForecastWeatherData(ForecastParams forecastParams) async {
    try {
      Response response = await apiProvider.get7DaysForecast(forecastParams);

      if (response.statusCode == 200) {
        ForecastDaysEntity forecastDaysEntity = ForecastDaysModel.fromJson(response.data);
        return DataSuccess(forecastDaysEntity);
      } else {
        return const DataFailed("Somthing went wrong. try again...");
      }
    } catch (e) {
      return const DataFailed("Please check your connection");
    }
  }

  @override
  Future<List<Data>> fetchSuggestData(cityName) async {
    Response response = await apiProvider.searchCity(cityName);
    SuggestCityEntity suggestCityEntity = SuggestCityModel.fromJson(response.data);
    return suggestCityEntity.data!;
  }
}
