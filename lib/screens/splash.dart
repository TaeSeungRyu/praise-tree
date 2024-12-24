import 'dart:io';

import 'package:custom_image_crop/custom_image_crop.dart';
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
      var isRemoveCropedImage = await controller?.cropedImage?.value.exists();
      if(isRemoveCropedImage == true){
        controller?.cropedImage?.value?.deleteSync();
        controller?.cropedImage?.refresh();
      }
      controller.previewImage.value = File(image.path);
      controller.previewImage.refresh();

      debugPrint("image path: ${controller.previewImage.value}");
    }
  }

  Widget generateCropToImageWidget(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [
//const controller.previewImage.value,
            controller.previewImage.value!.existsSync()
                ? CustomImageCrop(
                    cropController: controller.cropController,
                    image: FileImage(controller.previewImage.value!),
                    borderRadius: 1,
                  )
                : Container(),

            ElevatedButton(
              onPressed: () => controller.cropImage(context),
              child: Text('Crop Image'),
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Pickaa Images"),
                ),
                SizedBox(height: 30),
                controller.cropedImage.value!.existsSync()
                    ? ClipOval(
                        child: Image.file(
                          controller.cropedImage.value!,
                          fit: BoxFit.contain,
                        ),
                      )
                    : const Text("empty"),
              ],
            )
          ],
        ),
        onPanUpdate: (details) {
          final Offset newPosition = controller.center.value + details.delta;
          controller.center.value = newPosition;
        },
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
                      ? generateCropToImageWidget(context)
                      : ElevatedButton(
                          onPressed: _pickImage,
                          child: const Text("Pick an Imag aa e"),
                        )
                ],
              ),
            ),
          ),
        ));
  }
}
//
// class CirclePainter extends CustomPainter {
//   final Offset circleCenter;
//   final double radius;
//
//   CirclePainter({required this.circleCenter, required this.radius});
//
//   @override
//   void paint(Canvas canvas, Size size) {
//     final fillPaint = Paint()
//       ..color = Colors.blue.withOpacity(0.3) // 원 내부 색상
//       ..style = PaintingStyle.fill;
//
//     final strokePaint = Paint()
//       ..color = Colors.blue.withOpacity(0.5)
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 2;
//
//     canvas.drawCircle(circleCenter, radius, strokePaint);
//     canvas.drawCircle(circleCenter, radius, fillPaint);
//   }
//
//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
