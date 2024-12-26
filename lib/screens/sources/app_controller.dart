import 'dart:io';
import 'dart:math';
import 'dart:typed_data';


import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_heart_son/screens/tree.dart';

import 'app_vo.dart';


class AppController extends GetxController with WidgetsBindingObserver {
  static AppController get to => Get.find();

  RxString splashImagePath = 'assets/icons/splash-background.png'.obs;
  RxString treePath = 'assets/icons/tree.png'.obs;
  RxString appMainText = 'treeeeeee'.obs;


  Rx<Color> splashColor = Colors.white.obs;
  CustomImageCropController cropController = CustomImageCropController();
  Rx<File> previewImage = File("").obs;  //미리보기 이미지
  Rx<File> cropedImage = File("").obs; //자른 이미지
  final Rx<Offset> center = const Offset(200, 300).obs; //디바이스의 중앙


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint("image path: ${image.path}");
      var isRemoveCropedImage = await cropedImage?.value.exists();
      if(isRemoveCropedImage == true){
        cropedImage?.value?.deleteSync();
        cropedImage?.refresh();
      }
      previewImage.value = File(image.path);
      previewImage.refresh();
    }
  }

  Future<void> cropImage(BuildContext context) async {
    var image = await cropController.onCropImage();
    if(image != null){
      debugPrint("image: $image");
      var randomString = Random().nextInt(10000);
      cropedImage.value =
          await File('${previewImage!.value!.path}_cropped_$randomString.png').writeAsBytes(image.bytes);
      cropedImage.refresh();
    }
  }

  void initCenterPosition(context) {
    final screenSize = MediaQuery.of(context).size;
    center.value = Offset(screenSize.width / 2, screenSize.height / 2);
  }
  ////splash Timer
  Future<void> runTimer() async {
    await Future.delayed(const Duration(seconds: 4));
    Get.offNamed(Tree.routeName);
  }

  //TODO : 키 값을 스토리지에 저장하고, 스토리지에서 값을 가져오기
  RxList<String> treeList = <String>["Item 1", "Item 2", "Item 3", "Item 4"].obs;
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  RxList<MarkPositionVo> positionList = <MarkPositionVo>[].obs;

}
