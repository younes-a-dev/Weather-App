import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/widgets/ui/main_wrapper.dart';
import 'features/bookmark_feature/presentation/bloc/bookmark_bloc.dart';
import 'features/weather_feature/presentation/bloc/home_bloc.dart';
import 'features/weather_feature/presentation/screens/home_screen.dart';
import 'locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init locator
  await setup();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => locator<HomeBloc>()),
          BlocProvider(create: (_) => locator<BookmarkBloc>()),
        ],
        child:  MainWrapper(),
      ),
    ),
  );
}