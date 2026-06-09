// 4. Verify Code Screen
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../routes/approute.dart';
import '../widget/auth_widget.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final _codeController = TextEditingController();
  String currentCode = '';

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              SizedBox(height: 20.h),

          // Back button
          const AuthBackButton(),

          // Logo
          Center(child: const AuthLogo()),


          // Title
          Center(
            child: Text(
              'Check your email',
              style: TextStyle(
                fontSize: 26.sp,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),

          SizedBox(height: 16.h),

          Center(
            child: Text(
              'We sent a code to contact@dscode...com. Enter 6 digit code that mentioned in the email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF888888),
                height: 1.5,
              ),
            ),
          ),

          SizedBox(height: 32.h),

          // 6-digit code input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: PinCodeTextField(
              appContext: context,
              length: 6,
              obscureText: false,
              animationType: AnimationType.fade,
              keyboardType: TextInputType.number,
              controller: _codeController,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(12.r),
                fieldHeight: 56.h,
                fieldWidth: 48.w,
                activeFillColor: Colors.white,
                inactiveFillColor: Colors.white,
                selectedFillColor: Colors.white,
                activeColor: const Color(0xFFD4A843),
                inactiveColor: const Color(0xFFE0E0E0),
                selectedColor: const Color(0xFFD4A843),
                borderWidth: 1.2,
              ),
              animationDuration: const Duration(milliseconds: 300),
              backgroundColor: Colors.transparent,
              enableActiveFill: true,
              onCompleted: (v) {
                setState(() {
                  currentCode = v;
                });
              },
              onChanged: (value) {
                setState(() {
                  currentCode = value;
                });
              },
            ),
          ),

          SizedBox(height: 28.h),

          // Verify Code button
          AuthPrimaryButton(
            label: 'Verify Code',
            onTap: () {
              // Handle code verification
              Get.toNamed(AppRoutes.resetPass);
            },
          ),

          SizedBox(height: 20.h),

          // Resend email
          Center(
            child: GestureDetector(
              onTap: () {
                // Handle resend email
              },
              child: Text(
                'Haven\'t got the email yet? Resend email',
              style: TextStyle(
                fontSize: 13.sp,
                color: const Color(0xFF888888),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        SizedBox(height: 24.h),
        ],
      ),
    ),
    ),
    );
  }
}