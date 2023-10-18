import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:weather_app/features/bookmark_feature/presentation/bloc/bookmark_bloc.dart';
import 'package:weather_app/features/weather_feature/data/models/current_city_model.dart';
import 'package:weather_app/features/weather_feature/domain/usecase/get_suggestion_city_usecase.dart';
import 'package:weather_app/features/weather_feature/presentation/bloc/cw_status.dart';
import 'package:weather_app/features/weather_feature/presentation/bloc/home_bloc.dart';

import '../../../../core/params/forecast_params.dart';
import '../../../../core/utils/date_converter.dart';
import '../../../../core/widgets/weather_icons.dart';
import '../../../../locator.dart';
import '../../data/models/forecast_days_model.dart';
import '../../data/models/suggest_city_model.dart';
import '../../domain/entities/current_city_entity.dart';
import '../../domain/entities/forecast_days_entity.dart';
import '../bloc/fw_status.dart';
import '../widgets/bookmark_icon.dart';
import 'day_weather_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin{
  TextEditingController searchCityController = TextEditingController();

  GetSuggestionCityUseCase getSuggestionCityUseCase = GetSuggestionCityUseCase(locator());
  String _cityName = 'Ardabil';

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(_cityName));
  }

  Widget _buildRow(String imgUrl, String title, String value) {
    return SizedBox(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            width: 50,
            height: 50,
            imgUrl,
            color: Colors.yellow,
          ),
          const SizedBox(width:10),
          Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.amber,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TypeAheadField(
                textFieldConfiguration: TextFieldConfiguration(
                  onSubmitted: (String prefix) {
                    searchCityController.text = prefix;
                    BlocProvider.of<HomeBloc>(context)
                        .add(LoadCwEvent(prefix));
                  },
                  controller: searchCityController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.withOpacity(.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0),
                    ),
                    hintText: 'Search for city...',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    suffixIcon: const Icon(Icons.search),
                    suffixIconColor: const Color(0xffffd600),
                    contentPadding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0),
                    ),
                    disabledBorder: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: Colors.transparent, style: BorderStyle.none, width: 0),
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                  ),),
                suggestionsCallback: (String prefix){
                  return getSuggestionCityUseCase(prefix);
                },
                itemBuilder: (context, Data model){
                  return ListTile(
                    leading: const Icon(Icons.location_on),
                    title: Text(model.name!),
                    subtitle: Text("${model.region!}, ${model.country!}"),
                  );
                },
                onSuggestionSelected: (Data model){
                  searchCityController.text = model.name!;
                  BlocProvider.of<HomeBloc>(context).add(LoadCwEvent(model.name!));
                }
            ),
          ),
          Container(
            height: size.height * .7,
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 5, top: 5),
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) {
                if (previous.cwStatus == current.cwStatus) {
                  return false;
                }
                return true;
              },
              builder: (context, state) {
                // loading state
                if (state.cwStatus is CwLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                // loaded state
                if (state.cwStatus is CwCompleted) {
                  //cast
                  final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                  final CurrentCityEntity currentCityEntity = cwCompleted.currentCityEntity;

                  /// create params for api call
                  final ForecastParams forecastParams = ForecastParams(currentCityEntity.coord!.lat!, currentCityEntity.coord!.lon!);

                  /// start load Fw event
                  BlocProvider.of<HomeBloc>(context).add(LoadFwEvent(forecastParams));

                  /// change Times to Hour --5:55 AM/PM----
                  final sunrise = DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunrise, currentCityEntity.timezone);
                  final sunset = DateConverter.changeDtToDateTimeHour(currentCityEntity.sys!.sunset, currentCityEntity.timezone);

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currentCityEntity.name.toString(),
                            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                          ),


                          BlocBuilder<HomeBloc,HomeState>(
                            buildWhen: (previous,current){
                              if(previous.cwStatus == current.cwStatus){
                                return false;
                              }
                              return true;
                            },
                            builder:(context,state){
                              
                              // Loading state
                              if(state.cwStatus is CwLoading){
                                return const CircularProgressIndicator();
                              }
                              
                              // Error State
                              if(state.cwStatus is CwError){
                                return IconButton(
                                  onPressed: (){},
                                  icon: const Icon(Icons.error,color: Colors.white,),
                                );
                              }
                              
                              // Completed state
                              if(state.cwStatus is CwCompleted){
                                final CwCompleted cwCompleted = state.cwStatus as CwCompleted;
                                BlocProvider.of<BookmarkBloc>(context).add(GetCityByNameEvent(cwCompleted.currentCityEntity.name!));
                                return BookmarkIcon(name:cwCompleted.currentCityEntity.name!);
                              }
                              return Container();
                            }
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Weather Icon
                            SizedBox(height: 70, width: 70, child: WeatherIcons.setWeatherIcon(currentCityEntity.weather![0].description!)),

                            // Description and temp
                            Column(
                              children: [
                                Text(
                                  currentCityEntity.weather![0].description!.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "${currentCityEntity.main!.temp!.round()}\u00B0",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                // max temp
                                Row(
                                  children: [
                                    const Text(
                                      "max",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${currentCityEntity.main!.tempMax!.round()}\u00B0",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),

                                // divider
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 10.0,
                                    bottom: 10,
                                  ),
                                  child: Container(
                                    color: Colors.yellow,
                                    width: 40,
                                    height: 1,
                                  ),
                                ),

                                /// min temp
                                Row(
                                  children: [
                                    const Text(
                                      "min",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "${currentCityEntity.main!.tempMin!.round()}\u00B0",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        color: Colors.yellow,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                          child: Column(
                            mainAxisAlignment : MainAxisAlignment.spaceAround,
                            children: [
                              // sunrise and sunset
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildRow('assets/images/sunrise.png', "sunrise", sunrise),
                                  _buildRow('assets/images/sunset.png', "sunset", sunset),
                                ],
                              ),

                              // Humidity and wind speed
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildRow('assets/images/humidity.png', "Humidity", "${currentCityEntity.main!.humidity!}%"),
                                  _buildRow('assets/images/windspeed.png', "Wind Speed", "${currentCityEntity.wind!.speed!} m/s"),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.yellow,
                      ),

                      // forecast weather 7 days
                      Padding(
                        padding: const EdgeInsets.only(top: 30,bottom: 30),
                        child: SizedBox(
                          width: double.infinity,
                          height: 100,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Center(
                              child: BlocBuilder<HomeBloc, HomeState>(
                                builder: (BuildContext context, state) {
                                  // show Loading State for Fw
                                  if (state.fwStatus is FwLoading) {
                                    return const Center(child: CircularProgressIndicator());
                                  }

                                  // Completed State for Fw
                                  if (state.fwStatus is FwCompleted) {
                                    // casting
                                    final FwCompleted fwCompleted = state.fwStatus as FwCompleted;
                                    final ForecastDaysEntity forecastDaysEntity = fwCompleted.forecastDaysEntity;
                                    final List<Daily> mainDaily = forecastDaysEntity.daily!;

                                    return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: 8,
                                      itemBuilder: (
                                        BuildContext context,
                                        int index,
                                      ) {
                                        return DaysWeatherView(
                                          daily: mainDaily[index],
                                        );
                                      },
                                    );
                                  }

                                  // Error State for Fw
                                  if (state.fwStatus is FwError) {
                                    final FwError fwError = state.fwStatus as FwError;
                                    return Center(
                                      child: Text(fwError.message!),
                                    );
                                  }

                                  // Default State
                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                // error State
                if (state.cwStatus is CwError) {
                  return const Center(child: Text("Something went Wrong..."));
                }

                return Container();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
