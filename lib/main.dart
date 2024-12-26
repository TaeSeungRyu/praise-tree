import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_heart_son/router/router.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';
import 'package:my_heart_son/screens/splash.dart';
import 'package:my_heart_son/utils/display_util.dart';
import 'package:get/get.dart';

void main() async {
  await ScreenUtil.ensureScreenSize();
  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});
  static const String firstPage = Splash.routeName;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DisplayUtil.initVertical(context, designHeight: 914, designWidth: 412);

    return GetMaterialApp(
      title: '칭찬나무',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'CookieRun',
        scaffoldBackgroundColor: Colors.white,
      ),
      initialBinding: _InitBinding(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('ko'),
      fallbackLocale: const Locale('ko', 'KR'),
      getPages: route(),
      initialRoute: firstPage,
      builder: (BuildContext context, Widget? child) {
        final MediaQueryData data = MediaQuery.of(context);
        return ScrollConfiguration(
          behavior: MyBehavior(),
          child: MediaQuery(
            data: data.copyWith(textScaler: const TextScaler.linear(1)),
            child: child!,
          ),
        );
      },
    );
  }
}

class _InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController(), permanent: true);
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}


