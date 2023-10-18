import 'package:get_it/get_it.dart';
import 'package:weather_app/features/bookmark_feature/data/data_source/local/database.dart';
import 'package:weather_app/features/weather_feature/data/data_source/remote/api_provider.dart';
import 'package:weather_app/features/weather_feature/data/repository/weather_repository_impl.dart';
import 'package:weather_app/features/weather_feature/domain/repository/weather_repository.dart';
import 'package:weather_app/features/weather_feature/domain/usecase/get_current_weather_usecase.dart';
import 'package:weather_app/features/weather_feature/presentation/bloc/home_bloc.dart';

import 'features/bookmark_feature/data/repository/city_repositoryImpl.dart';
import 'features/bookmark_feature/domain/repository/city_repository.dart';
import 'features/bookmark_feature/domain/usecase/delete_city_usecase.dart';
import 'features/bookmark_feature/domain/usecase/get_all_city_usecase.dart';
import 'features/bookmark_feature/domain/usecase/get_city_usecase.dart';
import 'features/bookmark_feature/domain/usecase/save_city_usecase.dart';
import 'features/bookmark_feature/presentation/bloc/bookmark_bloc.dart';
import 'features/weather_feature/domain/usecase/get_forecast_weather_usecase.dart';


GetIt locator = GetIt.instance;

setup()async{
  locator.registerSingleton<ApiProvider>(ApiProvider());


  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  locator.registerSingleton<AppDatabase>(database);

  //repositories
  locator.registerSingleton<WeatherRepository>(WeatherRepositoryImpl(locator()));
  locator.registerSingleton<CityRepository>(CityRepositoryImpl(database.cityDao));

  //use cases
  locator.registerSingleton<GetCurrentWeatherUseCase>(GetCurrentWeatherUseCase(locator()));
  locator.registerSingleton<GetForecastWeatherUsecase>(GetForecastWeatherUsecase(locator()));
  locator.registerSingleton<GetCityUseCase>(GetCityUseCase(locator()));
  locator.registerSingleton<SaveCityUseCase>(SaveCityUseCase(locator()));
  locator.registerSingleton<GetAllCityUseCase>(GetAllCityUseCase(locator()));
  locator.registerSingleton<DeleteCityUseCase>(DeleteCityUseCase(locator()));


  //bloc
  locator.registerSingleton<HomeBloc>(HomeBloc(locator(),locator()));
  locator.registerSingleton<BookmarkBloc>(BookmarkBloc(locator(),locator(),locator(),locator()));
}