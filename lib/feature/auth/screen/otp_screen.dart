import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../controller/auth_controller.dart';
import '../widget/auth_widget.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.to;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              const AuthBackButton(),
              Center(child: const AuthLogo()),
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
              Obx(() => Center(
                child: Text(
                  controller.otpFlowType.value == 'register'
                      ? 'We sent a 6-digit code to your email to verify your account.'
                      : 'We sent a 6-digit code to your email to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              )),
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
                  controller: controller.otpController,
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
                  onCompleted: (v) => controller.otpController.text = v,
                  onChanged: (value) {},
                ),
              ),

              SizedBox(height: 28.h),

              // Verify Code button
              Obx(() => AuthPrimaryButton(
                label: controller.isLoading.value ? 'Verifying...' : 'Verify Code',
                onTap:  controller.verifyOtp,
              )),

              SizedBox(height: 20.h),

              // Resend email
              Center(
                child: Obx(() => GestureDetector(
                  onTap: controller.canResend.value ? controller.resendOtp : null,
                  child: Text(
                    controller.canResend.value
                        ? "Haven't got the email yet? Resend email"
                        : "Resend available in ${controller.otpTimerLabel}",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF888888),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}