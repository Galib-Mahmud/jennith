// lib/feature/home/controller/main_controller.dart

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

/// Owns the bottom-navigation state so ANY screen can switch tabs
/// (e.g. Home -> Chat after picking a coach, Saved -> Chat via "Open chat").
class MainController extends GetxController {
  static MainController get to => Get.isRegistered<MainController>()
      ? Get.find<MainController>()
      : Get.put(MainController(), permanent: true);

  static const int homeTab = 0;
  static const int chatTab = 1;
  static const int savedTab = 2;
  static const int profileTab = 3;
  static const int tabCount = 4;

  final RxInt currentIndex = homeTab.obs;

  void changeTab(int index) {
    if (index < 0 || index >= tabCount) return;
    // Close the keyboard when leaving a screen that had a text field open.
    FocusManager.instance.primaryFocus?.unfocus();
    currentIndex.value = index;
  }
}