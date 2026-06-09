import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../routes/approute.dart';
import '../widget/auth_widget.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController        = TextEditingController();
  final _emailController       = TextEditingController();
  final _phoneController       = TextEditingController();
  final _passwordController    = TextEditingController();
  final _confirmController     = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm  = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
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

              // Full Name
              AuthInputField(
                icon: Icons.person_outline,
                hint: 'Enter Full Name',
                controller: _nameController,
              ),

              SizedBox(height: 14.h),

              // Email
              AuthInputField(
                icon: Icons.mail_outline,
                hint: 'Enter Email Address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 14.h),

              // Mobile Number
              AuthInputField(
                icon: Icons.phone_outlined,
                hint: 'Enter Mobile Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
              ),

              SizedBox(height: 14.h),

              // Password
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

              SizedBox(height: 14.h),

              // Confirm Password
              AuthInputField(
                icon: Icons.lock_outline,
                hint: 'New Password a Second Time',
                obscure: _obscureConfirm,
                controller: _confirmController,
                suffix: GestureDetector(
                  onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  child: Icon(
                    _obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: const Color(0xFF999999),
                    size: 18.sp,
                  ),
                ),
              ),

              SizedBox(height: 28.h),

              // Sign Up button
              AuthPrimaryButton(
                label: 'Sign Up',
                onTap: () {

                },
              ),

              SizedBox(height: 16.h),

              // Sign In button
              AuthPrimaryButton(
                label: 'Sign In',
                onTap: () {
                  Get.toNamed(AppRoutes.signIn);

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