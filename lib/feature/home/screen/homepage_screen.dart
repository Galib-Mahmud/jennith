import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/core/endpoint/api_endpoint.dart';

import '../../../routes/approute.dart';
import '../controller/chat_controller.dart';
import '../controller/home_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  IconData _iconFor(String key) {
    switch (key) {
      case 'crown':
        return Icons.workspace_premium_outlined;
      case 'dollar':
        return Icons.attach_money;
      case 'users':
        return Icons.people_outline;
      case 'star':
        return Icons.star_border;
      default:
        return Icons.chat_bubble_outline;
    }
  }

  Color _colorFor(String hex) {
    try {
      final cleaned = hex.replaceFirst('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return const Color(0xFFD4A843);
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning,';
    if (hour < 17) return 'Good afternoon,';
    return 'Good evening,';
  }

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;

    return SafeArea(
      bottom: false,
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        child: Obx(() {
          if (controller.isLoading.value && controller.coaches.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            children: [
              SizedBox(height: 28.h),

              // Greeting
              Text(
                _greeting(),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFFD4A843),
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Obx(() => Text(
                '${controller.fullName.value.isEmpty ? 'there' : controller.fullName.value}! 👋',
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              )),
              SizedBox(height: 4.h),
              Text(
                'What do you want to learn today?',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF888888),
                ),
              ),

              SizedBox(height: 28.h),

              // Coach cards
              ...controller.coaches.map((coach) => _coachCard(
                icon: _iconFor(coach.icon),
                iconColor: _colorFor(coach.accentColor),
                title: coach.name,
                subtitle: coach.tagline,
                onTap: () async {
                  final sessionId = await ChatController.to.startNewChat(coach);
                  if (sessionId != null) {
                    Get.toNamed(ApiEndpoint.chats, arguments: {
                      'sessionId': sessionId,
                      'coach': coach,
                    });
                  }
                },
              )),

              SizedBox(height: 100.h),
            ],
          );
        }),
      ),
    );
  }

  Widget _coachCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: iconColor, size: 22.sp),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF888888),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}