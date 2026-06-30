import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../controller/auth_controller.dart';
import '../widget/auth_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.to;
    final RxBool obscurePassword = true.obs;
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
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
              SizedBox(height: 6.h),
              Center(
                child: Text(
                  'Create an account in just a few simple steps.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              AuthInputField(
                icon: Icons.person_outline,
                hint: 'Enter Full Name',
                controller: controller.fullNameController,
              ),

              SizedBox(height: 14.h),

              AuthInputField(
                icon: Icons.mail_outline,
                hint: 'Enter Email Address',
                controller: controller.signUpEmailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 14.h),

              AuthInputField(
                icon: Icons.phone_outlined,
                hint: 'Enter Mobile Number',
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 14.h),

              Obx(() => AuthInputField(
                icon: Icons.lock_outline,
                hint: 'Enter Password',
                obscure: obscurePassword.value,
                controller: controller.signUpPasswordController,
                suffix: GestureDetector(
                  onTap: () => obscurePassword.value = !obscurePassword.value,
                  child: Icon(
                    obscurePassword.value
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              )),

              SizedBox(height: 14.h),

              Obx(() => AuthInputField(
                icon: Icons.lock_outline,
                hint: 'New Password a Second Time',
                obscure: obscureConfirm.value,
                controller: controller.signUpConfirmController,
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

              SizedBox(height: 28.h),

              // Sign Up button
              Obx(() => AuthPrimaryButton(
                label: controller.isLoading.value ? 'Creating Account...' : 'Sign Up',
                onTap: controller.signUp
              )),

              SizedBox(height: 16.h),

              // Sign In button
              AuthPrimaryButton(
                label: 'Sign In',
                onTap: () => Get.toNamed(AppRoutes.signIn),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}