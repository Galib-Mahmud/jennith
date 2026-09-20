import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/routes/approute.dart';

class PricingScreen extends StatelessWidget {
  const PricingScreen({super.key});

  static const _features = [
    'All AI Coaches',
    'Voice input & replies',
    'Save & export chats',
    'Priority support',
    'Lifetime updates',
    'Save & export chats',
    'Priority support',
    'Voice input & replies',
    'Lifetime updates',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFBFB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 36.h),

              // Crown logo at top
              _buildCrownLogo(),

              SizedBox(height: 20.h),

              // Title
              Text(
                'Choose Your Plan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30.sp,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A1A),
                ),
              ),

              SizedBox(height: 8.h),

              // Subtitle
              Text(
                'Unlock full access to Jenni AI\nMentor!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: const Color(0xFF888888),
                  height: 1.5,
                ),
              ),

              SizedBox(height: 32.h),

              // Plan card
              _buildPlanCard(),

              SizedBox(height: 28.h),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Crown Logo Widget
  Widget _buildCrownLogo() {
    return Column(
      children: [
        CustomPaint(
          size: Size(52.w, 40.h),
          painter: CrownPainter(),
        ),
        SizedBox(height: 8.h),
        // Underline bar below crown
        Container(
          width: 52.w,
          height: 3.h,
          decoration: BoxDecoration(
            color: const Color(0xFFE6BF5B),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
      ],
    );
  }

  // Small crown icon for Lifetime Access
  Widget _buildSmallCrown() {
    return CustomPaint(
      size: Size(18.w, 14.h),
      painter: CrownPainter(),
    );
  }

  Widget _buildPlanCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFE8D9B8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lifetime Access label with crown icon
          Row(
            children: [
              _buildSmallCrown(),
              SizedBox(width: 6.w),
              Text(
                'Lifetime Access',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFE6BF5B),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Price
          Text(
            '\$199',
            style: TextStyle(
              fontSize: 44.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFE6BF5B),
              height: 1.1,
            ),
          ),

          SizedBox(height: 18.h),

          // Feature list
          ..._features.map((feature) => _buildFeatureItem(feature)),

          SizedBox(height: 22.h),

          // CONTINUE button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () {
                 // Get.toNamed(AppRoutes.signUp);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE6BF5B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(26.r),
                ),
              ),
              child: Text(
                'CONTINUE',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Icon(Icons.check, color: const Color(0xF3D4A843), size: 16.sp),
          SizedBox(width: 10.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: const Color(0xFF333333),
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Crown Painter
class CrownPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A843)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final fillPaint = Paint()
      ..color = const Color(0xFFD4A843)
      ..style = PaintingStyle.fill;

    // Draw crown shape
    final path = Path();

    // Starting point (bottom left)
    path.moveTo(size.width * 0.1, size.height * 0.9);

    // Left side up to first point
    path.lineTo(size.width * 0.1, size.height * 0.4);

    // First peak
    path.lineTo(size.width * 0.25, size.height * 0.7);

    // Second peak (middle, highest)
    path.lineTo(size.width * 0.5, size.height * 0.1);

    // Third peak
    path.lineTo(size.width * 0.75, size.height * 0.7);

    // Right side down
    path.lineTo(size.width * 0.9, size.height * 0.4);
    path.lineTo(size.width * 0.9, size.height * 0.9);

    // Bottom line
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, paint);

    // Add decorative circles on peaks
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.7),
      2.5,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.1),
      3,
      fillPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.75, size.height * 0.7),
      2.5,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}