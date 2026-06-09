import 'package:get/get.dart';
import 'package:nail_gpt/feature/auth/screen/account_create_sucessfully.dart';
import 'package:nail_gpt/feature/auth/screen/forgetpass_screen.dart';
import 'package:nail_gpt/feature/auth/screen/otp_screen.dart';
import 'package:nail_gpt/feature/auth/screen/reset_pass_screen.dart';
import 'package:nail_gpt/feature/auth/screen/sign_in_screen.dart';
import 'package:nail_gpt/feature/auth/screen/signup_screen.dart';
import 'package:nail_gpt/feature/home/screen/bottom_nav_bar.dart';
import 'package:nail_gpt/feature/home/screen/personal_information_screen.dart';
import 'package:nail_gpt/feature/home/screen/privacy_screen.dart';
import '../feature/onboarding/screen/onboarding_screen1.dart';
import '../feature/onboarding/screen/onboarding_screen2.dart';
import '../feature/onboarding/screen/onboarding_screen3.dart';
import '../feature/onboarding/screen/pricing_screen.dart';
import '../feature/onboarding/screen/splash_screen.dart';
import 'approute.dart';

abstract class AppPages {
  static final pages = [


    // Onboarding

    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen1(),
    ),
    GetPage(
      name: AppRoutes.onboarding2,
      page: () => const OnboardingScreen2(),
    ),
    GetPage(
      name: AppRoutes.onboarding3,
      page: () => const OnboardingScreen3(),
    ),
    GetPage(
      name: AppRoutes.pricing,
      page: () => const PricingScreen(),
    ),




    //Authentication
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpScreen(),
    ),
    GetPage(
      name: AppRoutes.signIn,
      page: () => const SignInScreen(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: AppRoutes.verifyCode,
      page: () => const VerifyCodeScreen(),
    ),GetPage(
      name: AppRoutes.resetPass,
      page: () => const ResetPasswordScreen(),
    ),GetPage(
      name: AppRoutes.accountCreated,
      page: () => const AccountCreatedScreen(),
    ),GetPage(
      name: AppRoutes.main,
      page: () => const MainScreen(),
    ),GetPage(
      name: AppRoutes.personal,
      page: () => const PersonalInformationScreen(),
    ),GetPage(
      name: AppRoutes.privacy,
      page: () => const PrivacyPolicyScreen(),
    ),GetPage(
      name: AppRoutes.terms,
      page: () => const AccountCreatedScreen (),
    ),





  ];
}