import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_heart_son/sources/app_controller.dart';

class ImageSelector extends GetView<AppController> {
  const ImageSelector({super.key});

  static const routeName = "/selector";

  Widget generateCropToImageWidget(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        child: Stack(
          alignment: Alignment.center,
          children: [
            controller.previewImage.value!.existsSync()
                ? CustomImageCrop(
                    cropController: controller.cropController,
                    image: FileImage(controller.previewImage.value!),
                    borderRadius: 1,
                  )
                : Container(),
            controller.cropedImage.value!.existsSync()
                ? ClipOval(
              child: Image.file(
                controller.cropedImage.value!,
                fit: BoxFit.cover,
                scale: 6,
              ),
            )
                :  Container(),
            Positioned(
              bottom: 80,
              child: ElevatedButton(
                onPressed: controller.pickImage,
                child: const Text("이미지 다시 선택"),
              ),
            ),
            Positioned(
              bottom: 20,
              child: ElevatedButton(
                onPressed: () => controller.cropImage(context),
                child: const Text('이미지 자르기'),
              ),
            )
          ],
        ),
        onPanUpdate: (details) {
          final Offset newPosition = controller.center.value + details.delta;
          controller.center.value = newPosition;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.cropedImage.value!.existsSync()
                    ? ClipOval(
                        child: Image.file(
                          controller.cropedImage.value!,
                          fit: BoxFit.cover,
                          scale: 6,
                        ),
                      )
                    : Container(),
                controller.previewImage.value!.existsSync()
                    ? generateCropToImageWidget(context)
                    : ElevatedButton(
                        onPressed: controller.pickImage,
                        child: const Text("사진 고르기"),
                      ),
                controller.cropedImage.value!.existsSync()
                    ? ElevatedButton(
                        onPressed: () {
                          controller.saveImage(context);
                        },
                        child: const Text("이미지 적용하기"),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
