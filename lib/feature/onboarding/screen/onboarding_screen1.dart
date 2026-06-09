import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({super.key});

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
                      SizedBox(height: 40.h),
                      _buildTitle(),
                      SizedBox(height: 10.h),
                      _buildSubtitle(),
                      SizedBox(height: 32.h),
                      _buildPhoneMockup(),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ),
            _buildNextButton(context),
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
            text: 'Learn From NailGPT,\n',
            style: TextStyle(
              fontSize: 30.sp,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
              height: 1.35,
            ),
          ),
          TextSpan(
            text: 'Anytime, Anywhere',
            style: TextStyle(
              fontSize: 34.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFD4A843),
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Get expert guidance on everything nail\nbusiness — on demand.',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14.sp,
        color: const Color(0xFF666666),
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildPhoneMockup() {
    return Center(
      child: Container(
        width: 260.w,
        height: 460.h,
        decoration: BoxDecoration(
          color: const Color(0xFF0D1B2A),
          borderRadius: BorderRadius.circular(38.r),
          border: Border.all(color: const Color(0xFF1C3355), width: 2.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(36.r),
          child: Column(
            children: [
              _buildPhoneNotch(),
              _buildChatHeader(),
              Container(height: 1, color: Colors.white.withOpacity(0.08)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(14.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 6.h),
                      _buildUserBubble('How do I scale my nail\nbusiness to 6 figures?'),
                      SizedBox(height: 10.h),
                      _buildAiBubble("Here's my proven framework to help you scale with confidence and clarity..."),
                    ],
                  ),
                ),
              ),
              _buildVoiceBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNotch() {
    return Container(
      height: 26.h,
      color: const Color(0xFF0D1B2A),
      alignment: Alignment.center,
      child: Container(
        width: 72.w,
        height: 18.h,
        decoration: BoxDecoration(
          color: const Color(0xFF162030),
          borderRadius: BorderRadius.circular(9.r),
        ),
      ),
    );
  }

  Widget _buildChatHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Business',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFD4A843),
                  ),
                ),
                TextSpan(
                  text: 'Coach',
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // AI avatar circle - peach/pink
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: const Color(0xFFE8C8A8),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFD4A843), width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              'AI',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF5A3E1B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserBubble(String text) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(maxWidth: 185.w),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2D3D),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
            bottomLeft: Radius.circular(14.r),
            bottomRight: Radius.circular(3.r),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(fontSize: 12.sp, color: Colors.white, height: 1.4),
        ),
      ),
    );
  }

  Widget _buildAiBubble(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // small round avatar
        Container(
          width: 30.w,
          height: 30.h,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF3A3A3A),
          ),
          child: ClipOval(
            child: Icon(Icons.person, size: 18.sp, color: Colors.white60),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
            decoration: BoxDecoration(
              color: const Color(0xFF1E2D3D),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.r),
                topRight: Radius.circular(14.r),
                bottomLeft: Radius.circular(14.r),
                bottomRight: Radius.circular(14.r),
              ),
            ),
            child: Text(
              text,
              style: TextStyle(fontSize: 12.sp, color: Colors.white, height: 1.4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVoiceBar() {
    return Container(
      margin: EdgeInsets.all(10.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF182233),
        borderRadius: BorderRadius.circular(28.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 28.h,
              child: CustomPaint(painter: _WaveformPainter()),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            width: 36.w,
            height: 36.h,
            decoration: const BoxDecoration(
              color: Color(0xFFD4A843),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mic, color: Colors.white, size: 18.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
      child: SizedBox(
        width: double.infinity,
        height: 54.h,
        child: ElevatedButton(
          onPressed: () => Get.toNamed(AppRoutes.onboarding2),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4A843),
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

class _WaveformPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD4A843)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final heights = [0.35, 0.55, 0.85, 0.50, 0.70, 0.30, 0.80, 0.45,
      0.60, 0.40, 0.75, 0.90, 0.50, 0.65, 0.35, 0.75,
      0.30, 0.55, 0.45, 0.65];
    final spacing = size.width / (heights.length * 2 - 1);
    final centerY = size.height / 2;

    for (int i = 0; i < heights.length; i++) {
      final x = i * spacing * 2;
      final h = (heights[i] * size.height) / 2;
      canvas.drawLine(Offset(x, centerY - h), Offset(x, centerY + h), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}