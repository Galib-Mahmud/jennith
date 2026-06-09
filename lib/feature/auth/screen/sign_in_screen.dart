import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../widget/auth_widget.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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


              // Logo centered
              Center(child: const AuthLogo()),

              SizedBox(height: 36.h),

              // Title
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
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 14.h),

              // Password field
              AuthInputField(
                icon: Icons.lock_outline,
                hint: 'Enter Password',
                obscure: _obscurePassword,
                controller: _passwordController,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscurePassword = !_obscurePassword),
                  child: Icon(
                    _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              ),

              SizedBox(height: 10.h),

              // Forget Password
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    
                    Get.toNamed(AppRoutes.forgotPassword);

                  },
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
              AuthPrimaryButton(
                label: 'Sign In',
                onTap: () {
                  // Handle sign in

                  Get.toNamed(AppRoutes.main);
                },
              ),

              SizedBox(height: 12.h),

              // Sign Up button
              AuthPrimaryButton(
                label: 'Sign Up',
                onTap: () {

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