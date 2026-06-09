import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: [
            SizedBox(height: 28.h),

            // ── Greeting ──────────────────────────────────────
            Text(
              'Good morning,',
              style: TextStyle(
                fontSize: 22.sp,
                fontStyle: FontStyle.italic,
                color: const Color(0xFFD4A843),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Nail Queen! 👑',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'What do you want to learn today?',
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF888888),
              ),
            ),

            SizedBox(height: 28.h),

            // ── Coach cards ───────────────────────────────────
            _coachCard(
              icon: Icons.workspace_premium_outlined,
              iconColor: const Color(0xFFD4A843),
              title: 'Business Coach',
              subtitle: 'Grow, scale and build a profitable nail business.',
            ),
            _coachCard(
              icon: Icons.attach_money,
              iconColor: const Color(0xFFD4A843),
              title: 'Pricing Coach',
              subtitle: 'Price your services right and maximize profits.',
            ),
            _coachCard(
              icon: Icons.people_outline,
              iconColor: const Color(0xFF4CAF50),
              title: 'Client Growth Coach',
              subtitle: 'Attract, retain and grow your dream clientele.',
            ),
            _coachCard(
              icon: Icons.star_border,
              iconColor: const Color(0xFFAB47BC),
              title: 'Content Coach',
              subtitle: 'Create content that attracts and converts.',
            ),

            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }

  Widget _coachCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
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
          // Icon box
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
          // Text
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
    );
  }
}