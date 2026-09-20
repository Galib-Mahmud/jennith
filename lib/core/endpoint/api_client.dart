// lib/core/endpoint/api_client.dart

import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter/foundation.dart' show kDebugMode, debugPrint;
import 'package:http/http.dart' as http;

import '../../feature/auth/controller/auth_controller.dart';
import '../../feature/auth/controller/token_refresher.dart';
import '../local_storage/user_info.dart';

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({required this.baseUrl, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  // ─── Default headers (no auth) ────────────────────────────────────
  final Map<String, String> _defaultHeaders = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  // ─── URL Builder ──────────────────────────────────────────────────
  String _buildUrl(String endpoint) {
    final base = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final path = endpoint.startsWith('/') ? endpoint : '/$endpoint';
    return '$base$path';
  }

  // ─── Auth Header ──────────────────────────────────────────────────
  // Reads token from in-memory cache — SYNCHRONOUS, zero async gap.
  // Called again on every attempt, so a retry after a token refresh
  // automatically uses the NEW access token.
  Map<String, String> _authHeaders() {
    final token = UserInfo.getAccessTokenSync();
    return {
      ..._defaultHeaders,
      if (token != null && token.isNotEmpty) "Authorization": "Bearer $token",
    };
  }

  Map<String, String> _headers(bool requiresAuth, Map<String, String>? extra) =>
      {
        ...(requiresAuth ? _authHeaders() : _defaultHeaders),
        ...?extra,
      };

  // ─── Core request runner (handles 401 -> refresh -> retry) ────────
  Future<dynamic> _request(
      Future<http.Response> Function() send,
      Uri url, {
        required String method,
        required bool requiresAuth,
      }) async {
    final tokenUsed = UserInfo.getAccessTokenSync();
    var response = await send();

    if (response.statusCode == 401 && requiresAuth) {
      final current = UserInfo.getAccessTokenSync();

      if (current != null && current.isNotEmpty && current != tokenUsed) {
        // Another request already refreshed the token while this one was
        // in flight -> just retry with the new token.
        response = await send();
      } else {
        final result = await TokenRefresher.refresh();
        if (result == RefreshResult.success) {
          response = await send(); // retry once with the new access token
        } else if (result == RefreshResult.invalid) {
          // Refresh token expired / rejected -> back to sign-in.
          await AuthController.to.logout();
        }
        // RefreshResult.unavailable (offline / server down): keep the user
        // signed in, the original 401 is thrown below.
      }
    }

    return _handleResponse(response, url, method: method);
  }

  // ─── GET ──────────────────────────────────────────────────────────
  Future<dynamic> get(
      String endpoint, {
        Map<String, String>? headers,
        bool requiresAuth = true,
        Map<String, String?>? queryParameters,
      }) async {
    var url = Uri.parse(_buildUrl(endpoint));
    if (queryParameters != null) {
      final query = {
        for (final e in queryParameters.entries)
          if (e.value != null) e.key: e.value!,
      };
      if (query.isNotEmpty) {
        url = url.replace(
          queryParameters: {...url.queryParameters, ...query},
        );
      }
    }
    _logRequest("GET", url, _headers(requiresAuth, headers), null);
    return _request(
          () => _httpClient.get(url, headers: _headers(requiresAuth, headers)),
      url,
      method: "GET",
      requiresAuth: requiresAuth,
    );
  }

  // ─── POST ─────────────────────────────────────────────────────────
  Future<dynamic> post(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("POST", url, _headers(requiresAuth, headers), body);
    return _request(
          () => _httpClient.post(url,
          headers: _headers(requiresAuth, headers), body: encodedBody),
      url,
      method: "POST",
      requiresAuth: requiresAuth,
    );
  }

  // ─── PUT ──────────────────────────────────────────────────────────
  Future<dynamic> put(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("PUT", url, _headers(requiresAuth, headers), body);
    return _request(
          () => _httpClient.put(url,
          headers: _headers(requiresAuth, headers), body: encodedBody),
      url,
      method: "PUT",
      requiresAuth: requiresAuth,
    );
  }

  // ─── PATCH ────────────────────────────────────────────────────────
  Future<dynamic> patch(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("PATCH", url, _headers(requiresAuth, headers), body);
    return _request(
          () => _httpClient.patch(url,
          headers: _headers(requiresAuth, headers), body: encodedBody),
      url,
      method: "PATCH",
      requiresAuth: requiresAuth,
    );
  }

  // ─── DELETE ───────────────────────────────────────────────────────
  Future<dynamic> delete(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));
    final encodedBody = body != null ? jsonEncode(body) : null;
    _logRequest("DELETE", url, _headers(requiresAuth, headers), body);
    return _request(
          () => _httpClient.delete(url,
          headers: _headers(requiresAuth, headers), body: encodedBody),
      url,
      method: "DELETE",
      requiresAuth: requiresAuth,
    );
  }

  // ─── MULTIPART ────────────────────────────────────────────────────
  Future<dynamic> multipart(
      String endpoint, {
        required String method,
        Map<String, String>? fields,
        Map<String, File>? files,
        bool requiresAuth = true,
      }) async {
    final url = Uri.parse(_buildUrl(endpoint));

    // A MultipartRequest can only be sent once, so it is rebuilt on every
    // attempt (needed for the retry after a token refresh).
    Future<http.Response> send() async {
      final request = http.MultipartRequest(method, url);
      final token = requiresAuth ? UserInfo.getAccessTokenSync() : null;
      if (token != null && token.isNotEmpty) {
        request.headers["Authorization"] = "Bearer $token";
      }
      request.headers["Accept"] = "application/json";
      if (fields != null) request.fields.addAll(fields);
      if (files != null) {
        for (final entry in files.entries) {
          request.files.add(
              await http.MultipartFile.fromPath(entry.key, entry.value.path));
        }
      }
      return http.Response.fromStream(await request.send());
    }

    _log("🌐 [$method MULTIPART] URL: $url");
    _log("📋 Fields: $fields");
    _log("📎 Files: ${files?.keys.toList()}");

    return _request(
      send,
      url,
      method: "$method MULTIPART",
      requiresAuth: requiresAuth,
    );
  }

  // ─── Response Handler ─────────────────────────────────────────────
  dynamic _handleResponse(http.Response response, Uri url,
      {required String method}) {
    _log("📩 [$method] Status: ${response.statusCode}");
    _log("📩 [$method] Body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      try {
        return jsonDecode(response.body);
      } catch (e) {
        throw HttpException(
          message: "Invalid JSON format",
          statusCode: response.statusCode,
          uri: url,
          body: response.body,
        );
      }
    }

    String errorMessage = "Request failed";
    try {
      final errorBody = jsonDecode(response.body);
      if (errorBody is Map<String, dynamic>) {
        if (errorBody.containsKey('detail')) {
          errorMessage = errorBody['detail'].toString();
        } else {
          errorMessage = errorBody.entries.map((e) {
            final val = e.value;
            if (val is List) return "${e.key}: ${val.join(', ')}";
            return "${e.key}: $val";
          }).join(" | ");
        }
      }
    } catch (_) {
      errorMessage =
      response.body.isNotEmpty ? response.body : "Request failed";
    }

    switch (response.statusCode) {
      case 400:
        throw HttpException(
            message: errorMessage,
            statusCode: 400,
            uri: url,
            body: response.body);
      case 401:
        throw UnauthorizedException(uri: url, body: response.body);
      case 403:
        throw ForbiddenException(uri: url, body: response.body);
      case 404:
        throw NotFoundException(uri: url, body: response.body);
      case 500:
      case 502:
      case 503:
        throw ServerException(uri: url, body: response.body);
      default:
        throw HttpException(
            message: errorMessage,
            statusCode: response.statusCode,
            uri: url,
            body: response.body);
    }
  }

  // ─── Logger (debug builds only, token hidden) ─────────────────────
  void _log(String message) {
    if (kDebugMode) debugPrint(message);
  }

  void _logRequest(String method, Uri url, Map<String, String> headers,
      dynamic body) {
    if (!kDebugMode) return;
    final safeHeaders = {
      for (final e in headers.entries)
        e.key: e.key.toLowerCase() == 'authorization' ? 'Bearer ***' : e.value,
    };
    debugPrint("─────────────────────────────────────");
    debugPrint("🌐 [$method] $url");
    debugPrint("📋 Headers: $safeHeaders");
    if (body != null) debugPrint("📦 Body: $body");
    debugPrint("─────────────────────────────────────");
  }
}

// ─── Exceptions ───────────────────────────────────────────────────
class HttpException implements Exception {
  final String message;
  final int statusCode;
  final Uri uri;
  final String? body;

  const HttpException({
    required this.message,
    required this.statusCode,
    required this.uri,
    this.body,
  });

  @override
  String toString() => "HttpException [$statusCode]: $message | URL: $uri";
}

class UnauthorizedException extends HttpException {
  UnauthorizedException({required Uri uri, String? body})
      : super(
      message: "Unauthorized. Please log in again.",
      statusCode: 401,
      uri: uri,
      body: body);
}

class ForbiddenException extends HttpException {
  ForbiddenException({required Uri uri, String? body})
      : super(
      message: "Access denied.",
      statusCode: 403,
      uri: uri,
      body: body);
}

class NotFoundException extends HttpException {
  NotFoundException({required Uri uri, String? body})
      : super(
      message: "Resource not found.",
      statusCode: 404,
      uri: uri,
      body: body);
}

class ServerException extends HttpException {
  ServerException({required Uri uri, String? body})
      : super(
      message: "Server error. Please try again later.",
      statusCode: 500,
      uri: uri,
      body: body);
}