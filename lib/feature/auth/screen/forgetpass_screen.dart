import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/auth_controller.dart';
import '../widget/auth_widget.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
                  'Forgot password',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              Center(
                child: Text(
                  'Please enter your email to reset the password',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 32.h),

              AuthInputField(
                icon: Icons.mail_outline,
                hint: 'Enter Email Address',
                controller: controller.forgotEmailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 36.h),

              Obx(() => AuthPrimaryButton(
                label: controller.isLoading.value ? 'Sending...' : 'Reset Password',
                onTap:  controller.forgotPassword,
              )),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}