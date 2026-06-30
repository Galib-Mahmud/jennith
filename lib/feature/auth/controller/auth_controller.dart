// lib/feature/auth/controllers/auth_controller.dart

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../routes/approute.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.put(AuthController(), permanent: true);

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  final RxBool isLoading = false.obs;

  // OTP flow type: 'register' | 'forgot_password'
  final RxString otpFlowType = 'register'.obs;

  // ─── OTP Timer ────────────────────────────────────────────────────
  final RxInt otpTimerSeconds = 60.obs;
  final RxBool canResend = false.obs;
  Timer? _otpTimer;

  // ─── SignUp Controllers ───────────────────────────────────────────
  final fullNameController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final phoneController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmController = TextEditingController();

  // ─── SignIn Controllers ───────────────────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // ─── Forgot Password Controllers ─────────────────────────────────
  final forgotEmailController = TextEditingController();

  // ─── Reset Password Controllers ───────────────────────────────────
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ─── OTP Controller (single pin field, used by pin_code_fields) ──
  final otpController = TextEditingController();

  // ─────────────────────────────────────────────────────────────────
  // OTP TIMER
  // ─────────────────────────────────────────────────────────────────
  void startOtpTimer() {
    _otpTimer?.cancel();
    otpTimerSeconds.value = 60;
    canResend.value = false;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimerSeconds.value > 0) {
        otpTimerSeconds.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  String get otpTimerLabel {
    final m = (otpTimerSeconds.value ~/ 60).toString().padLeft(1, '0');
    final s = (otpTimerSeconds.value % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  // ─────────────────────────────────────────────────────────────────
  // SIGN UP
  // POST /auth/signup/
  // body: full_name, email, mobile_number, password, confirm_password
  // ─────────────────────────────────────────────────────────────────
  Future<void> signUp() async {
    if (fullNameController.text.trim().isEmpty ||
        signUpEmailController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        signUpPasswordController.text.isEmpty ||
        signUpConfirmController.text.isEmpty) {
      _showError('Please fill all required fields');
      return;
    }
    if (signUpPasswordController.text != signUpConfirmController.text) {
      _showError('Passwords do not match');
      return;
    }

    isLoading.value = true;
    try {
      await _apiClient.post(
        ApiEndpoint.signUp,
        body: {
          'full_name': fullNameController.text.trim(),
          'email': signUpEmailController.text.trim(),
          'mobile_number': phoneController.text.trim(),
          'password': signUpPasswordController.text,
          'confirm_password': signUpConfirmController.text,
        },
        requiresAuth: false,
      );

      await UserInfo.setUserEmail(signUpEmailController.text.trim());
      otpFlowType.value = 'register';
      otpController.clear();
      startOtpTimer();
      _showSuccess('Account created. Check your email for the code.');
      Get.toNamed(AppRoutes.verifyCode);
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      print('❌ SignUp error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // VERIFY OTP (shared by register + forgot-password flows)
  // ─────────────────────────────────────────────────────────────────
  Future<void> verifyOtp() async {
    final code = otpController.text.trim();
    if (code.length < 6) {
      _showError('Please enter the complete 6-digit code');
      return;
    }

    if (otpFlowType.value == 'register') {
      await _verifyRegistrationOtp(code);
    } else {
      await _verifyForgotPasswordOtp(code);
    }
  }

  // POST /auth/verify-email/  { email, code }
  Future<void> _verifyRegistrationOtp(String code) async {
    isLoading.value = true;
    try {
      final email = await UserInfo.getUserEmail();
      await _apiClient.post(
        ApiEndpoint.verifyEmail,
        body: {'email': email, 'code': code},
        requiresAuth: false,
      );
      _otpTimer?.cancel();
      _showSuccess('Email verified successfully. You can now sign in.');
      Get.offAllNamed(AppRoutes.signIn);
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // POST /auth/verify-reset-otp/  { email, code } -> { reset_token }
  Future<void> _verifyForgotPasswordOtp(String code) async {
    isLoading.value = true;
    try {
      final email = await UserInfo.getForgotPasswordEmail();
      final response = await _apiClient.post(
        ApiEndpoint.verifyResetOtp,
        body: {'email': email, 'code': code},
        requiresAuth: false,
      );
      final resetToken = response?['reset_token']?.toString();
      if (resetToken != null) {
        await UserInfo.setResetToken(resetToken);
      }
      _otpTimer?.cancel();
      Get.toNamed(AppRoutes.resetPass);
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // RESEND OTP
  // POST /auth/resend-otp/  { email, purpose }   (registration)
  // POST /auth/forgot-password/ { email }        (reset flow resend)
  // ─────────────────────────────────────────────────────────────────
  Future<void> resendOtp() async {
    if (!canResend.value) return;

    if (otpFlowType.value == 'register') {
      await _resendRegistrationOtp();
    } else {
      await _resendForgotPasswordOtp();
    }
  }

  Future<void> _resendRegistrationOtp() async {
    final email = await UserInfo.getUserEmail();
    if (email == null) return;
    isLoading.value = true;
    try {
      await _apiClient.post(
        ApiEndpoint.resendOtp,
        body: {'email': email, 'purpose': 'email_verification'},
        requiresAuth: false,
      );
      startOtpTimer();
      _showSuccess('A new code has been sent to your email');
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _resendForgotPasswordOtp() async {
    final email = await UserInfo.getForgotPasswordEmail();
    if (email == null) return;
    isLoading.value = true;
    try {
      await _apiClient.post(
        ApiEndpoint.forgotPassword,
        body: {'email': email},
        requiresAuth: false,
      );
      startOtpTimer();
      _showSuccess('A new code has been sent to your email');
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // SIGN IN
  // POST /auth/signin/  { email, password } -> { access, refresh, user }
  // ─────────────────────────────────────────────────────────────────
  Future<void> signIn() async {
    if (emailController.text.trim().isEmpty || passwordController.text.isEmpty) {
      _showError('Please enter your email and password');
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.post(
        ApiEndpoint.signIn,
        body: {
          'email': emailController.text.trim(),
          'password': passwordController.text,
        },
        requiresAuth: false,
      );

      if (response != null) {
        final user = response['user'] as Map<String, dynamic>?;

        await UserInfo.setAccessToken(response['access'] ?? '');
        await UserInfo.setRefreshToken(response['refresh'] ?? '');
        await UserInfo.setFullName(user?['full_name'] ?? '');

        Get.offAllNamed(AppRoutes.main);
      }
    } on ForbiddenException catch (e) {
      // Email not verified — backend auto-resends a code
      final body = _tryParseBody(e.body);
      _showError(_extractMessage(body) ?? 'Email not verified.');
      await UserInfo.setUserEmail(emailController.text.trim());
      otpFlowType.value = 'register';
      otpController.clear();
      startOtpTimer();
      Get.toNamed(AppRoutes.verifyCode);
    } on UnauthorizedException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? 'Invalid email or password');
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      print('❌ Login error: $e');
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // FORGOT PASSWORD
  // POST /auth/forgot-password/  { email }
  // ─────────────────────────────────────────────────────────────────
  Future<void> forgotPassword() async {
    if (forgotEmailController.text.trim().isEmpty) {
      _showError('Please enter your email address');
      return;
    }

    isLoading.value = true;
    try {
      await _apiClient.post(
        ApiEndpoint.forgotPassword,
        body: {'email': forgotEmailController.text.trim()},
        requiresAuth: false,
      );
      await UserInfo.setForgotPasswordEmail(forgotEmailController.text.trim());
      otpFlowType.value = 'forgot_password';
      otpController.clear();
      startOtpTimer();
      Get.toNamed(AppRoutes.verifyCode);
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // RESET PASSWORD
  // POST /auth/reset-password/  { reset_token, password, confirm_password }
  // ─────────────────────────────────────────────────────────────────
  Future<void> resetPassword() async {
    if (newPasswordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty) {
      _showError('Please fill in all fields');
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      _showError('Passwords do not match');
      return;
    }
    if (newPasswordController.text.length < 8) {
      _showError('Password must be at least 8 characters');
      return;
    }

    isLoading.value = true;
    try {
      final resetToken = await UserInfo.getResetToken();
      await _apiClient.post(
        ApiEndpoint.resetPassword,
        body: {
          'reset_token': resetToken,
          'password': newPasswordController.text,
          'confirm_password': confirmPasswordController.text,
        },
        requiresAuth: false,
      );

      await UserInfo.clearForgotPasswordEmail();
      await UserInfo.clearResetToken();
      newPasswordController.clear();
      confirmPasswordController.clear();
      Get.offAllNamed(AppRoutes.accountCreated);
    } on HttpException catch (e) {
      _showError(_extractMessage(_tryParseBody(e.body)) ?? e.message);
    } catch (e) {
      _showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // ─────────────────────────────────────────────────────────────────
  // PARSERS
  // ─────────────────────────────────────────────────────────────────
  Map<String, dynamic>? _tryParseBody(String? body) {
    if (body == null || body.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return null;
  }

  String? _extractMessage(Map<String, dynamic>? body) {
    if (body == null) return null;
    if (body.containsKey('detail')) return body['detail'].toString();
    if (body.containsKey('message')) return body['message'].toString();
    for (final entry in body.entries) {
      final val = entry.value;
      if (val is Map && val.containsKey('message')) return val['message'].toString();
      if (val is List && val.isNotEmpty) return val.first.toString();
      if (val is String) return val;
    }
    return null;
  }

  // ─────────────────────────────────────────────────────────────────
  // SNACKBARS
  // ─────────────────────────────────────────────────────────────────
  void _showError(String message) => Get.snackbar(
    "Error", message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.red.shade700,
    colorText: Colors.white,
    icon: const Icon(Icons.error_outline, color: Colors.white),
    margin: const EdgeInsets.all(12),
    borderRadius: 10,
    duration: const Duration(seconds: 5),
  );

  void _showSuccess(String message) => Get.snackbar(
    "Success", message,
    snackPosition: SnackPosition.TOP,
    backgroundColor: Colors.green.shade700,
    colorText: Colors.white,
    icon: const Icon(Icons.check_circle_outline, color: Colors.white),
    margin: const EdgeInsets.all(12),
    borderRadius: 10,
    duration: const Duration(seconds: 3),
  );

  @override
  void onClose() {
    _otpTimer?.cancel();
    super.onClose();
  }
}