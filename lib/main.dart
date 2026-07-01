// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nail_gpt/core/local_storage/user_info.dart';
import 'package:nail_gpt/routes/approute.dart';
import 'package:nail_gpt/routes/pages.dart';

import 'feature/auth/controller/auth_controller.dart';

Future<void> main() async {                          // ← async added
  WidgetsFlutterBinding.ensureInitialized();

  await UserInfo.init();                             // ← must be before runApp

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  Get.put(AuthController(), permanent: true);        // ← init once here

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
        );
      },
    );
  }
}