import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learning_app/features/home/HomeScreen.dart';
import 'package:learning_app/features/screen2/Screen2.dart';
import 'package:learning_app/features/screen3/Screen3.dart';
import 'package:learning_app/features/screen4/Screen4.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    Get.put(NavigationController());

    return Scaffold(
      body: GetX<NavigationController>(
        builder: (controller) {
          return controller.Screen[controller.selectedIndex.value];
        },
      ),
      bottomNavigationBar: GetX<NavigationController>(
        builder: (controller) {
          return ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.red,
              currentIndex: controller.selectedIndex.value,
              onTap: (index) => controller.selectedIndex.value = index,
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.home_filled,
                    color: CupertinoColors.systemGrey,
                  ),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.surround_sound_rounded,
                    color: CupertinoColors.systemGrey,
                  ),
                  label: "Listening",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.quiz_rounded,
                    color: CupertinoColors.systemGrey,
                  ),
                  label: "Quiz",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.translate_sharp,
                    color: CupertinoColors.systemGrey,
                  ),
                  label: "Translate",
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;
  final Screen = [
    HomeScreen(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];
}
