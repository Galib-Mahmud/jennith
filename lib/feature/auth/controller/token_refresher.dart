// lib/core/endpoint/token_refresher.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';

enum RefreshResult {
  /// New access (+ refresh) token saved.
  success,

  /// Refresh token missing, expired or rejected by the server -> user must log in again.
  invalid,

  /// No internet / server error. Do NOT log the user out.
  unavailable,
}

class TokenRefresher {
  // If many requests fail with 401 together, they all share ONE refresh call.
  // (With rotating refresh tokens a second call with the old token would be rejected.)
  static Future<RefreshResult>? _inFlight;

  static Future<RefreshResult> refresh() {
    return _inFlight ??= _doRefresh().whenComplete(() => _inFlight = null);
  }

  // POST /auth/token/refresh/  { "refresh": "..." }  ->  { "access": "...", "refresh": "..." }
  static Future<RefreshResult> _doRefresh() async {
    final refresh = await UserInfo.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return RefreshResult.invalid;

    try {
      final res = await http
          .post(
        Uri.parse('${ApiEndpoint.baseUrl}${ApiEndpoint.tokenRefresh}'),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'refresh': refresh}),
      )
          .timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body) as Map<String, dynamic>;
        final access = data['access']?.toString();
        final newRefresh = data['refresh']?.toString();

        if (access == null || access.isEmpty) return RefreshResult.invalid;

        await UserInfo.setAccessToken(access);
        // Server rotates the refresh token, so the new one must be saved too.
        if (newRefresh != null && newRefresh.isNotEmpty) {
          await UserInfo.setRefreshToken(newRefresh);
        }
        return RefreshResult.success;
      }

      if (res.statusCode == 400 ||
          res.statusCode == 401 ||
          res.statusCode == 403) {
        return RefreshResult.invalid;
      }
      return RefreshResult.unavailable; // 5xx etc.
    } catch (_) {
      return RefreshResult.unavailable; // timeout / no internet
    }
  }
}