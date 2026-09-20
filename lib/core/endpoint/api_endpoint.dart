// lib/core/endpoint/api_endpoint.dart

class ApiEndpoint {
  static const String baseUrl = 'https://nailapi.sobhoy.com/api';

  // ─── Auth ──────────────────────────────────────────────────────────
  static const String signUp         = "/auth/signup/";
  static const String signIn         = "/auth/signin/";
  static const String verifyEmail    = "/auth/verify-email/";
  static const String resendOtp      = "/auth/resend-otp/";
  static const String forgotPassword = "/auth/forgot-password/";
  static const String verifyResetOtp = "/auth/verify-reset-otp/";
  static const String resetPassword  = "/auth/reset-password/";
  static const String tokenRefresh   = "/auth/token/refresh/";
  static const String me             = "/auth/me/";

  // ─── App: Home ─────────────────────────────────────────────────────
  static const String home   = "/app/home/";
  static const String coaches = "/app/coaches/";

  // ─── App: Chat ─────────────────────────────────────────────────────
  static const String chats = "/app/chats/";
  static String chatDetail(String sessionId) => "/app/chats/$sessionId/";
  static String chatMessages(String sessionId) => "/app/chats/$sessionId/messages/";

  // ─── App: Profile ──────────────────────────────────────────────────
  static const String profile          = "/app/profile/";
  static const String changePassword   = "/app/profile/change-password/";
  static const String upgradeInfo      = "/app/profile/upgrade/";

  // ─── App: Saved ────────────────────────────────────────────────────
  static const String saved = "/app/saved/";
  static String savedItem(String savedId) => "/app/saved/$savedId/";
}