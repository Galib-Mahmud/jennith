import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [

              // NailGPT Logo image at top
              Image.asset(
                'assets/images/splash.png',
                width: 200.w,
                fit: BoxFit.contain,
              ),

              // Your 24/7 Nail Business Coach
              _buildTitle(),


              // Portrait image with gold circle border + dots
              Expanded(child: _buildPortrait()),

              // GET STARTED button
              _buildGetStartedButton(),

              SizedBox(height: 20.h),

              // Log In button
              _buildLogInButton(),

              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          TextSpan(
            text: 'Your ',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
          TextSpan(
            text: '24/7',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFD4A843),
              height: 1.3,
            ),
          ),
          TextSpan(
            text: '\nNail Business Coach',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait() {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [

          // Portrait photo
          ClipOval(
            child: Image.asset(
              'assets/images/coach.png',
              fit: BoxFit.contain,
              // Shows a grey placeholder if image not found
              errorBuilder: (context, error, stackTrace) => Container(
                width: 222.w,
                height: 222.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDEB8B0),
                ),
                child: Icon(
                  Icons.person,
                  size: 90.sp,
                  color: Colors.white54,
                ),
              ),
            ),
          ),

          // Dot top-right
          Positioned(
            top: 12.h,
            right: 18.w,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: Color(0xFF999999),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Dot bottom-left
          Positioned(
            bottom: 12.h,
            left: 18.w,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: Color(0xFF999999),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGetStartedButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: ElevatedButton(
        onPressed: () => Get.toNamed(AppRoutes.pricing),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A843),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          'GET STARTED',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLogInButton() {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
      child: OutlinedButton(
        onPressed: () {
          // Get.toNamed(AppRoutes.login);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFD4A843), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
        ),
        child: Text(
          'Log In',
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A1A1A),
          ),
        ),
      ),
    );
  }
}