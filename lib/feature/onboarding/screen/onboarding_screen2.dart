import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      _buildTitle(),
                      SizedBox(height: 10.h),
                      _buildSubtitle(),
                      SizedBox(height: 36.h),
                      _buildFeatureLayout(),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
            ),
            _buildNextButton(),
          ],
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
            text: 'Built For Nail Techs\n',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.35,
            ),
          ),
          TextSpan(
            text: 'Who Want More',
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE6BF5B),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'From pricing to branding, content to\nclients — we\'ve got you covered.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF666666),
        height: 1.6,
      ),
    );
  }

  Widget _buildFeatureLayout() {
    return Column(
      children: [
        // Top: Pricing Strategies (centered)
        Center(
          child: _buildFeatureCard(
            icon: Icons.sell_outlined,
            title: 'Pricing Strategies',
            subtitle: 'Charge your worth and\nmaximize profits.',
            width: 170.w,

          ),
        ),
        SizedBox(height: 12.h),

        // Middle row: Business Growth | Crown Image Circle | Client Growth
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.trending_up,
                title: 'Business Growth',
                subtitle: 'Scale your business and increase income.',


              ),
            ),
            SizedBox(width: 10.w),

            // Center gold crown circle — image asset
            Container(
              width: 76.w,
              height: 76.w,
              decoration: const BoxDecoration(
                color: Color(0xFFE6BF5B),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Image.asset(
                  'assets/images/crown.png',
                  height: 30.h,
                  width: 30.w,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.workspace_premium,
                    color: Colors.white,
                    size: 30.sp,
                  ),
                ),
              ),
            ),

            SizedBox(width: 10.w),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.people_outline,
                title: 'Client Growth',
                subtitle: 'Attract, retain and grow\nloyal clients.',
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Bottom row: Content Creation | Mindset & More
        Row(
          children: [
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.camera_alt_outlined,
                title: 'Content Creation',
                subtitle: 'Create content that\nattracts and converts.',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildFeatureCard(
                icon: Icons.psychology_outlined,
                title: 'Mindset & More',
                subtitle: 'Level up your mindset\nand become elite.',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // ✅ icon center
        children: [
          Container(
            width: 30.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: const Color(0xFFF9F0DC),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFE6BF5B),
              size: 20.sp,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 9.sp,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
      child: SizedBox(
        width: double.infinity,
        height: 54.h,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(AppRoutes.onboarding3),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFE6BF5B),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
          ),
          child: Text(
            'NEXT',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}