import 'package:flutter/material.dart';
import 'package:weather_app/core/widgets/bottom_navigation.dart';

import '../../../features/bookmark_feature/presentation/screens/bookmark_screen.dart';
import '../../../features/weather_feature/presentation/screens/home_screen.dart';


class MainWrapper extends StatelessWidget {
   MainWrapper({Key? key}) : super(key: key);

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const HomeScreen(),
       BookmarkScreen(pageController: pageController,),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigation(controller: pageController,),
      body: Container(
        color: Colors.black,
        child: PageView(
          controller: pageController,
          children: pages ,
        )
      ),
    );
  }
}
