import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SupportAndLegalScreen extends StatelessWidget {
  const SupportAndLegalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Container(
              width: double.infinity,
              color: const Color(0xFFF5F5F5),
              padding: EdgeInsets.symmetric(vertical: 22.h),
              child: Text(
                'Support And Legal',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFD4A843),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            Divider(height: 1.h, color: const Color(0xFFE0E0E0)),

            // ── Body ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.w, vertical: 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Intro paragraph
                    Text(
                      'This Privacy Policy describes how we collect, use, and protect your information when you use our Money Management App ("we," "our," or "us"). By using the app, you agree to this policy.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF888888),
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: 28.h),

                    // Bullet group 1
                    _bulletItem('Personal details such as your name, email, and phone number.'),
                    _bulletItem('Financial data you enter manually, such as income, expenses, and savings goals.'),
                    _bulletItem('Device information (for performance and analytics).'),

                    SizedBox(height: 28.h),

                    // Bullet group 2
                    _bulletItem('To track and visualize your spending and income.'),
                    _bulletItem('To personalize insights, reminders, and budgeting tips.'),
                    _bulletItem('To improve app performance and user experience.'),

                    SizedBox(height: 28.h),

                    // Footer paragraph
                    Text(
                      'We use encryption and secure storage to keep your information safe. Your data is never sold to third parties.',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF888888),
                        height: 1.6,
                      ),
                    ),

                    SizedBox(height: 40.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h, right: 10.w),
            child: Container(
              width: 5.w,
              height: 5.w,
              decoration: const BoxDecoration(
                color: Color(0xFF888888),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.sp,
                color: const Color(0xFF888888),
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}