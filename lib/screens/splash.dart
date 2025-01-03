import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_heart_son/sources/app_controller.dart';
import 'package:my_heart_son/utils/display_util.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Splash extends GetView<AppController> {
  const Splash({super.key});

  static const routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requestStoragePermission(context);
      controller.splashColor.value = Colors.lightBlue;
      controller.runTimer();
    });
    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: AnimatedContainer(
            duration: const Duration(seconds: 2), // 애니메이션 지속 시간
            curve: Curves.easeInOut,
            color: controller.splashColor.value,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    controller.splashImagePath.value,
                    fit: BoxFit.cover,
                  ),
                  controller.isShowMainText.value
                      ? AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              controller.appMainText.value,
                              textStyle: TextStyle(
                                fontSize: 40.ratio,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              speed: const Duration(milliseconds: 120),
                              curve: Curves.easeInOut,
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 400),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //저장소 권한 요청
  Future<void> _requestStoragePermission(BuildContext context) async {
    //안드로이드가 아니거나 버전이 33 이상이면 권한 요청을 하지 않는다.
    if (!Platform.isAndroid) return;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) return;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        Get.snackbar(
          '저장소 권한',
          '저장소 권한이 허용 되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          '저장소 권한',
          '저장소 권한이 거부 되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
      }
    }
    return;
  }
}
