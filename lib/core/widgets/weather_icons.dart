import 'package:flutter/material.dart';

class WeatherIcons {
  static Image setWeatherIcon(description) {
    if (description == "clear sky") {
      return  const Image(image:  AssetImage('assets/images/day_clear.png',));
    } else if (description == "few clouds") {
      return const Image(image: AssetImage('assets/images/day_partial_cloud.png'));
    } else if (description.contains("clouds")) {
      return const Image(image: AssetImage('assets/images/cloudy.png'));
    } else if (description.contains("thunderstorm")) {
      return const Image(image: AssetImage('assets/images/rain_thunder.png'));
    } else if (description.contains("drizzle")) {
      return const Image(image: AssetImage('assets/images/day_rain.png'));
    } else if (description.contains("rain")) {
      return const Image(image: AssetImage('assets/images/rain.png'));
    } else if (description.contains("snow")) {
      return const Image(image: AssetImage('assets/images/snow.png'));
    } else {
      return const Image(image: AssetImage('assets/images/wind.png'));
    }
  }
}
