import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';
import 'package:image_picker/image_picker.dart';

class Splash extends GetView<AppController> {
  const Splash({super.key});

  static const routeName = "/splash";

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint("image path: ${image.path}");
      controller.previewImage.value = File(image.path);
      controller.previewImage.refresh();
      debugPrint("image path: ${controller.previewImage.value}");
    }
  }

  Widget generateCropToImageWidget() {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          InteractiveViewer(
            clipBehavior: Clip.none,
            minScale: 0.5,
            maxScale: 2.0,
            child: RepaintBoundary(
              key: controller.cropKey,
              child: Image.file(
                controller.previewImage.value!,
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 구멍이 있는 오버레이
          CustomPaint(
            size: Size.zero,
            painter: HolePainter(controller.center.value, controller.overlaySize),
            child: const IgnorePointer(
              ignoring: true, // 터치 이벤트를 무시
            ),
          ),

        ],
      ),
    );
    //TODO : 이미지 잘라서 뷰 하는거!!
    // ElevatedButton(
    // onPressed: controller.cropImage(),
    // child: Text("Crop Image"),
    // );
  }

  //TODO : 이미지 가운데 구멍뚫기 기능 만들고 분리하기 진행중
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.initCenterPosition(context);
    });

    return Obx(() => SafeArea(
          child: Scaffold(
            body: Center(
              child: Column(
                children: [
                  controller.previewImage.value!.existsSync()
                      ? generateCropToImageWidget()
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text("Pick an Image"),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}

// 구멍 오버레이를 그리는 Painter
class HolePainter extends CustomPainter {
  final Offset center;
  final double size;

  HolePainter(this.center, this.size);

  @override
  void paint(Canvas canvas, Size screenSize) {


    //IgnorePointer 가 있는 경우에 offset 값을 0 으로 해야 중앙으로 옵니다.
    //TODO : 정리 필요!
    debugPrint("Center Offset: $center, Screen Size: $screenSize"); // 디버그 출력

    Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    // 전체 화면을 덮는 반투명 레이어
    canvas.drawRect(Offset.zero & screenSize, paint);
    // 구멍 부분
    Paint circleColor = Paint()
      ..color = Colors.blue.withOpacity(0.3)
      ..style = PaintingStyle.fill;
    paint.blendMode = BlendMode.clear;
    canvas.drawCircle(Offset(0, 0), size / 2, circleColor);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
