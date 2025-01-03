
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_heart_son/sources/app_controller.dart';
import 'package:my_heart_son/utils/display_util.dart';

class Splash extends GetView<AppController> {
  const Splash({super.key});

  static const routeName = "/splash";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await controller.requestStoragePermission(context); //저장소 권한 요청(휴대폰 버전이 33 이하일 경우)
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

}
