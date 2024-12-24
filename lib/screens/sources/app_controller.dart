import 'dart:io';
import 'dart:math';
import 'dart:typed_data';


import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';


class AppController extends GetxController with WidgetsBindingObserver {
  static AppController get to => Get.find();

  RxString testText = 'asdf1234'.obs;
  Rx<File> previewImage = File("").obs;

  final GlobalKey cropKey = GlobalKey();
  final double overlaySize = 50; // 구멍 크기
  final Rx<Offset> center = const Offset(200, 300).obs; // 구멍의 위치

  Rx<File> cropedImage = File("").obs;

  CustomImageCropController cropController = CustomImageCropController();

  Future<void> cropImage(BuildContext context) async {
    var image = await cropController.onCropImage();
    if(image != null){
      debugPrint("image: $image");
      var randomString = Random().nextInt(10000);
      cropedImage.value =
          await File('${previewImage!.value!.path}_cropped_${randomString}.png').writeAsBytes(image.bytes);
      cropedImage.refresh();
    }
  }

  void initCenterPosition(context) {
    final screenSize = MediaQuery.of(context).size;
    center.value = Offset(screenSize.width / 2, screenSize.height / 2);
    debugPrint("center: ${center.value}");
  }
}
