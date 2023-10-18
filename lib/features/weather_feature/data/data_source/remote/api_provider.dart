import 'package:dio/dio.dart';

import '../../../../../core/params/forecast_params.dart';
import '../../../../../core/utils/constants.dart';


class ApiProvider {
  final Dio _dio = Dio();
  var apiKey = Constants.apiKeys1;

  // current weather api call
  Future<dynamic> getCurrentWeather(cityName) async {
    var response = await _dio.get(
        '${Constants.baseUrl}/data/2.5/weather',
        queryParameters: {
          'q': cityName,
          'appid': apiKey,
          'units': 'metric'
        }
    );
    return response;
  }


  // 7 days forecast api
  Future<dynamic> get7DaysForecast(ForecastParams params) async {

    var response = await _dio.get(
        "${Constants.baseUrl}/data/2.5/onecall",
        queryParameters: {
          'lat': params.lat,
          'lon': params.lon,
          'exclude': 'minutely,hourly',
          'appid': apiKey,
          'units': 'metric'
        });

    return response;
  }

  // city name suggest api
  Future<dynamic> searchCity(String prefix) async {
    var response = await _dio.get(
        "http://geodb-free-service.wirefreethought.com/v1/geo/cities",
        queryParameters: {'limit': 8, 'offset': 2, 'namePrefix': prefix});

    return response;
  }
}


