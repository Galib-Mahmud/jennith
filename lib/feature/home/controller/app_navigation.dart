// lib/core/navigation/app_navigator.dart


import 'bottom_nav_controller.dart';

/// One place that knows how to bring the Chat screen to the front.
/// Home ("tap a coach") and Saved ("Open chat") both call it.
class AppNavigator {
  const AppNavigator._();

  static void openChatTab() => MainController.to.changeTab(MainController.chatTab);
}