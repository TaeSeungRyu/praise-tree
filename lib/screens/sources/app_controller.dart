import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;


import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  static AppController get to => Get.find();

  RxString testText = 'asdf1234'.obs;
  Rx<File> previewImage = File("").obs;

  final GlobalKey cropKey = GlobalKey();
  final double overlaySize = 200; // 구멍 크기
  final Rx<Offset> center = const Offset(200, 300).obs; // 구멍의 위치

  Future<void> cropImage() async {
    var isFileExists =await previewImage.value.exists();
    if (!isFileExists) return;

    RenderRepaintBoundary boundary =
    cropKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    ByteData? byteData =
    await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      final pngBytes = byteData.buffer.asUint8List();
      // 저장하거나 다른 작업에 활용 가능
      // File croppedImage = File('path_to_save').writeAsBytesSync(pngBytes);
      debugPrint("이미지 잘라내기 성공!");
    }
  }


  void initCenterPosition(context) {
    final screenSize = MediaQuery.of(context).size;
    center.value = Offset(screenSize.width / 2, screenSize.height / 2);
    debugPrint("center: ${center.value}");
  }
}