import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_heart_son/screens/layout/app_bar_header.dart';
import 'package:my_heart_son/screens/layout/app_left_right_button.dart';
import 'package:my_heart_son/screens/setting.dart';
import 'package:my_heart_son/sources/app_controller.dart';

import 'package:my_heart_son/utils/display_util.dart';

class Tree extends GetView<AppController> {
  const Tree({super.key});

  static const routeName = "/tree";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initTreeConfigurationStyle(context);
      controller.initTreeConfiguration(context);
    });
    return Obx(
      () => SafeArea(
        child: Scaffold(
          appBar: appBarHeader(controller.appMainText.value, () {
            Get.toNamed(Setting.routeName);
          }),
          body: GestureDetector(
            behavior: HitTestBehavior.deferToChild, // 이벤트 전파 방지
            onTapDown: (TapDownDetails details) {
              controller.addApple(details, context);
            },
            child: Container(
              color: const Color.fromRGBO(79, 195, 247, 0.7),
              child: Stack(
                children: [
                  controller.treeSavedDataList[controller.currentPage.value]
                          .positionList.isNotEmpty
                      ? Positioned(
                          top: 10,
                          right: 20,
                          child: Text(
                            "도장 ${controller.treeSavedDataList[controller.currentPage.value].positionList.length}개!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.ratio,
                            ),
                          ),
                        )
                      : const SizedBox(),
                  Center(
                    child: PageView.builder(
                      itemCount: controller.treeSavedDataList.length,
                      controller: controller.pageController,
                      onPageChanged: (index) {
                        controller.currentPage.value = index;
                      },
                      itemBuilder: (context, index) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                controller.treePath.value,
                                fit: BoxFit.cover,
                                key: controller.treeKeyList[index],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  ...controller.currentPositionList.map((e) {
                    return Positioned(
                      left: e.x,
                      top: e.y,
                      child: controller.appleSavedPath.value.existsSync()
                          ? ClipOval(
                              child: Image.file(
                                controller.appleSavedPath.value,
                                fit: BoxFit.cover,
                                width: 45,
                                height: 45,
                              ),
                            )
                          : Image.asset(
                              controller.applePath.value,
                              fit: BoxFit.cover,
                              scale: 2,
                            ),
                    );
                  }).toList(),
                  Positioned(
                    bottom: 15,
                    right: controller.treeBottomTextLeftPosition.value,
                    child: Text(controller.treeBottomText.value),
                  ),
                  controller.currentPositionList.value.length >=
                          controller.maxAppleCount
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: const Color.fromRGBO(1, 1, 1, .4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                controller.finishPath.value,
                                fit: BoxFit.contain,
                                scale: 5,
                                opacity: const AlwaysStoppedAnimation(.75),
                              ),
                              Text(
                                controller.missionCompleteMessage.value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.ratio,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                controller
                                    .treeSavedDataList[
                                        controller.currentPage.value]
                                    .finishedDate,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.ratio,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(
                                width: 10,
                                height: 20,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  appLeftRightButton(context, true, () {
                    controller.leftMovePage();
                  }),
                  appLeftRightButton(context, false, () {
                    controller.rightMovePage();
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
