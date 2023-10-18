import 'package:flutter/material.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key? key, required this.controller}) : super(key: key);

  PageController controller;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: Colors.black,
      child: SizedBox(
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
                onPressed: () {
                  controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                },
                icon: const Icon(
                  Icons.home,
                  color: Colors.yellow,
                )),
            const SizedBox(),
            IconButton(
              onPressed: () {
                controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
              },
              icon: const Icon(
                Icons.bookmark,
                color: Colors.yellow,
              ),
            )
          ],
        ),
      ),
    );
  }
}
