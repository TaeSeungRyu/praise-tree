import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';
import 'package:my_heart_son/screens/sources/app_vo.dart';

class Tree extends GetView<AppController> {
  const Tree({super.key});

  static const routeName = "/tree";

  Widget generateSideLayout(
    BuildContext context,
    bool isLeft,
  ) {
    return Positioned(
      left: isLeft ? 10 : null,
      right: isLeft ? null : 10,
      top: MediaQuery.of(context).size.height / 2 - 60,
      child: IconButton(
        icon: isLeft
            ? const Icon(Icons.arrow_back_ios)
            : const Icon(Icons.arrow_forward_ios),
        onPressed: () {
          if (isLeft) {
            if (controller.currentPage.value > 0) {
              controller.pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          } else {
            if (controller.currentPage.value < controller.treeList.length - 1) {
              controller.pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: Scaffold(
            appBar: AppBar(
              title: Text(controller.appMainText.value),
              centerTitle: true,
              backgroundColor: Colors.lightBlue,
              actions: [
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () {
                    // Add more options functionality here
                  },
                ),
              ],
            ),
            body: GestureDetector(
              onTapDown: (TapDownDetails details) {
                final position = details.localPosition;
                debugPrint("Tapped at: (${position.dx}, ${position.dy})");
                var vo = MarkPositionVo(
                  x: position.dx,
                  y: position.dy,
                );
                controller.positionList.add(vo);
              },
              child: Stack(
                children: [
                  Center(
                    child: PageView.builder(
                      itemCount: controller.treeList.length,
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  generateSideLayout(context, true),
                  generateSideLayout(context, false),
                  ...controller.positionList.map((e) {
                    return Positioned(
                      left: e.x,
                      top: e.y,
                      child: Container(
                        width: 10,
                        height: 10,
                        color: Colors.red,
                      ),
                    );
                  }).toList()
                ],
              ),
            ),
          ),
        ));
  }
}
