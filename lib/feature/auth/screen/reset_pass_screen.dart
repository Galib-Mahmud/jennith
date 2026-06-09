// 1. Update Password Screen
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../widget/auth_widget.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
                  'Password reset',
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
                  'Enter your email address and we\'ll send you a link to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // New Password field
              AuthInputField(
                icon: Icons.lock_outline,
                hint: 'Enter your new password',
                obscure: _obscureNewPassword,
                controller: _newPasswordController,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                  child: Icon(
                    _obscureNewPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              ),

              SizedBox(height: 14.h),

              // Confirm Password field
              AuthInputField(
                icon: Icons.lock_outline,
                hint: 'New Password a Second Time',
                obscure: _obscureConfirmPassword,
                controller: _confirmPasswordController,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  child: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              ),

              SizedBox(height: 36.h),

              // Update Password button
              AuthPrimaryButton(
                label: 'Update Password',
                onTap: () {
                  Get.toNamed(AppRoutes.accountCreated);
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