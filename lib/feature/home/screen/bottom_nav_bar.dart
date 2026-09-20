import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/bottom_nav_controller.dart';
import 'chat_screen.dart';
import 'homepage_screen.dart';
import 'profile_screen.dart';
import 'saved_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});
  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const _gold = Color(0xFFD4A843);

  final MainController _tabs = MainController.to;

  // A tab is built the first time it is opened and then kept alive
  // (scroll position, typed text and chat state survive tab switches).
  final Set<int> _visited = {};

  static const List<Widget> _pages = [
    HomeScreen(),
    ChatsScreen(),
    SavedScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Start from initialIndex every time MainScreen is created (e.g. after re-login).
    _tabs.currentIndex.value = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Obx(() {
        final index = _tabs.currentIndex.value;
        _visited.add(index);
        return IndexedStack(
          index: index,
          children: [
            for (var i = 0; i < _pages.length; i++)
              _visited.contains(i) ? _pages[i] : const SizedBox.shrink(),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Obx(() {
      final current = _tabs.currentIndex.value;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        height: 72.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _navItem(Icons.home_outlined, 'Home', MainController.homeTab, current),
            _navItem(Icons.chat_bubble_outline, 'Chat', MainController.chatTab, current),
            _navItem(Icons.bookmark_border, 'Saved', MainController.savedTab, current),
            _navItem(Icons.person_outline, 'Profile', MainController.profileTab, current),
          ],
        ),
      );
    });
  }

  Widget _navItem(IconData icon, String label, int index, int current) {
    final bool isActive = current == index;

    return Semantics(
      button: true,
      selected: isActive,
      label: label,
      child: GestureDetector(
        onTap: () => _tabs.changeTab(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 64.w,
          height: 72.h,
          child: Center(
            child: isActive
                ? Container(
              width: 48.w,
              height: 48.w,
              decoration: const BoxDecoration(
                color: _gold,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 22.sp),
            )
                : Icon(icon, color: const Color(0xFF999999), size: 24.sp),
          ),
        ),
      ),
    );
  }
}