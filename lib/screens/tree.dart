import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_heart_son/screens/component/modals.dart';
import 'package:my_heart_son/screens/layout/app_bar_header.dart';
import 'package:my_heart_son/screens/layout/app_left_right_button.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';
import 'package:my_heart_son/screens/sources/app_vo.dart';
import 'package:my_heart_son/utils/display_util.dart';

class Tree extends GetView<AppController> {
  const Tree({super.key});

  static const routeName = "/tree";

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initTreeConfiguration(context);
      //confirmBox(context, "title", "content\ncontent\ncontent", (){}, (){});
      // explainSlideStyleBox(context,  (){
      //   runKeyPadModal(context, (){});
      // });
      runKeyPadModal(context, (){});
      //RunExplainSlideStyleBox(context,  () {});
    });
    return Obx(() => SafeArea(
          child: Scaffold(
            appBar: appBarHeader(controller.appMainText.value, () => {}),
            body: GestureDetector(
              behavior: HitTestBehavior.deferToChild, // 이벤트 전파 방지
              onTapDown: (TapDownDetails details) {
                controller.addApple(details);
              },
              child: Container(
                color: const Color.fromRGBO(110, 220, 145, 0.3),
                child: Stack(
                  children: [
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
                        child: Image.asset(
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
                                  scale: 3,
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
                      if (controller.currentPage.value > 0) {
                        controller.pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    }),
                    appLeftRightButton(context, false, () {
                      if (controller.currentPage.value <
                          controller.treeSavedDataList.length - 1) {
                        controller.pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
