// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/core/local_storage/user_info.dart';
import 'package:nail_gpt/routes/approute.dart';
import 'package:nail_gpt/routes/pages.dart';

import 'feature/auth/controller/auth_controller.dart';
import 'feature/auth/controller/token_refresher.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await UserInfo.init(); // must come before any UserInfo call

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final bool isAuthenticated = await _restoreSession();

  Get.put(AuthController(), permanent: true);

  runApp(MyApp(isAuthenticated: isAuthenticated));
}

/// true  -> open the main screen directly
/// false -> start from splash (sign up / sign in)
Future<bool> _restoreSession() async {
  // 1) Access token is saved -> go straight in.
  //    If it has expired, ApiClient refreshes it on the first 401 (see api_client.dart).
  if (UserInfo.isLoggedInSync()) return true;

  // 2) No access token, but a refresh token exists -> ask the server for new tokens.
  final refresh = await UserInfo.getRefreshToken();
  if (refresh == null || refresh.isEmpty) return false; // first launch / logged out

  final result = await TokenRefresher.refresh();
  switch (result) {
    case RefreshResult.success:
      return true; // new access + refresh token already saved
    case RefreshResult.unavailable:
      return true; // offline: keep the user signed in, retry on the first request
    case RefreshResult.invalid:
      await UserInfo.clearSession(); // refresh token expired -> sign in again
      return false;
  }
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated;
  const MyApp({super.key, this.isAuthenticated = false});

  String get initialRoute =>
      isAuthenticated ? AppRoutes.main : AppRoutes.splash;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'NailGPT',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.white,
            fontFamily: 'SF Pro Display',
          ),
          initialRoute: initialRoute,
          getPages: AppPages.pages,
        );
      },
    );
  }
}