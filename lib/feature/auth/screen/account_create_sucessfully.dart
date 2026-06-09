// 2. Account Created Successfully Screen
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../widget/auth_widget.dart';

class AccountCreatedScreen extends StatelessWidget {
  const AccountCreatedScreen({super.key});

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

              SizedBox(height: 28.h),

              // Logo
              Center(child: const AuthLogo()),

              SizedBox(height: 48.h),

              // Success Title
              Center(
                child: Text(
                  'Account Created Successfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),

              SizedBox(height: 16.h),

              Center(
                child: Text(
                  'Your account has been created. You can now log in and start exploring your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    height: 1.6,
                  ),
                ),
              ),

              SizedBox(height: 48.h),

              // Sign In button
              AuthPrimaryButton(
                label: 'Sign In',
                onTap: () {
                  Get.offAllNamed(AppRoutes.signIn);
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