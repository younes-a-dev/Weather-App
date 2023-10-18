import 'package:weather_app/features/weather_feature/domain/repository/weather_repository.dart';

import '../../../../core/usecase/usecase.dart';
import '../../data/models/suggest_city_model.dart';

class GetSuggestionCityUseCase implements UseCase <List<Data>,String>{
  final WeatherRepository _weatherRepository ;

  GetSuggestionCityUseCase(this._weatherRepository);

  @override
  // param = prefix string
  Future<List<Data>> call(String param) {
    return _weatherRepository.fetchSuggestData(param);
  }


}