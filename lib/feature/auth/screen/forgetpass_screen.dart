// 3. Forgot Password Screen
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../widget/auth_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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

              // Email field
              AuthInputField(
                icon: Icons.mail_outline,
                hint: 'Enter Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 36.h),

              // Reset Password button
              AuthPrimaryButton(
                label: 'Reset Password',
                onTap: () {
                  // Handle reset password
                  Get.toNamed(AppRoutes.verifyCode);
                },
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}