import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../controller/auth_controller.dart';
import '../widget/auth_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.to;
    final RxBool obscurePassword = true.obs;

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
              SizedBox(height: 36.h),
              Center(
                child: Text(
                  'Sign In',
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
                  'Enter your details to access your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: 28.h),

              // Email field
              AuthInputField(
                icon: Icons.mail_outline,
                hint: 'Enter Email Address',
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 14.h),

              // Password field
              Obx(() => AuthInputField(
                icon: Icons.lock_outline,
                hint: 'Enter Password',
                obscure: obscurePassword.value,
                controller: controller.passwordController,
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

              SizedBox(height: 10.h),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () => Get.toNamed(AppRoutes.forgotPassword),
                  child: Text(
                    'Forget Password?',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Sign In button
              Obx(() => AuthPrimaryButton(
                label: controller.isLoading.value ? 'Signing In...' : 'Sign In',
                onTap:  controller.signIn,
              )),

              SizedBox(height: 12.h),

              // Sign Up button
              AuthPrimaryButton(
                label: 'Sign Up',
                onTap: () => Get.toNamed(AppRoutes.signUp),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}