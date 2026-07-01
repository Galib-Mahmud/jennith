// lib/feature/auth/screen/reset_pass_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../widget/auth_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.to;
    final RxBool obscureNew     = true.obs;
    final RxBool obscureConfirm = true.obs;

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
                  'Enter your new password below to complete the reset.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: 32.h),

              // New password
              Obx(() => AuthInputField(
                icon: Icons.lock_outline,
                hint: 'Enter your new password',
                obscure: obscureNew.value,
                controller: controller.newPasswordController,
                suffix: GestureDetector(
                  onTap: () => obscureNew.value = !obscureNew.value,
                  child: Icon(
                    obscureNew.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              )),

              SizedBox(height: 14.h),

              // Confirm password
              Obx(() => AuthInputField(
                icon: Icons.lock_outline,
                hint: 'New Password a Second Time',
                obscure: obscureConfirm.value,
                controller: controller.confirmPasswordController,
                suffix: GestureDetector(
                  onTap: () => obscureConfirm.value = !obscureConfirm.value,
                  child: Icon(
                    obscureConfirm.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              )),

              SizedBox(height: 36.h),

              Obx(() => AbsorbPointer(
                absorbing: controller.isLoading.value,
                child: AuthPrimaryButton(
                  label: controller.isLoading.value
                      ? 'Updating...'
                      : 'Update Password',
                  onTap: controller.resetPassword,
                ),
              )),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}