import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:weather_app/core/params/forecast_params.dart';
import 'package:weather_app/features/weather_feature/presentation/bloc/fw_status.dart';

import '../../../../core/resources/data_state.dart';
import '../../domain/usecase/get_current_weather_usecase.dart';
import '../../domain/usecase/get_forecast_weather_usecase.dart';
import 'cw_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetCurrentWeatherUseCase getCurrentWeatherUseCase;
  final GetForecastWeatherUsecase _getForecastWeatherUsecase;

  HomeBloc(this.getCurrentWeatherUseCase,this._getForecastWeatherUsecase) : super(HomeState(cwStatus: CwLoading(), fwStatus: FwLoading())) {
    on<LoadCwEvent>((event, emit) async {
      emit(state.copyWith(newCwStatus: CwLoading()));

      DataState dataState = await getCurrentWeatherUseCase(event.cityName);

      if (dataState is DataSuccess) {
        emit(state.copyWith(newCwStatus: CwCompleted(dataState.data)));
      }
      if (dataState is DataFailed) {
        emit(state.copyWith(newCwStatus: CwError(dataState.error!)));
      }
    });

    on<LoadFwEvent>((event, emit) async {
      // emit Loading State
      emit(state.copyWith(newFwStatus: FwLoading()));

      DataState dataState = await _getForecastWeatherUsecase(event.forecastParams);

      // emit state to complete
      if (dataState is DataSuccess) {
        emit(state.copyWith(newFwStatus: FwCompleted(dataState.data)));
      }

      // emit state to error
      if (dataState is DataFailed) {
        emit(state.copyWith(newFwStatus: FwError(dataState.error)));
      }
    });
  }
}
