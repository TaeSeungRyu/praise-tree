
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';
import 'package:image_cropper/image_cropper.dart';

class Splash extends GetView<AppController> {
  const Splash({super.key});

  static const routeName = "/splash";


  initCropped(BuildContext context, String sourcePath) async {

    CroppedFile? croppedFile =  await ImageCropper().cropImage(
      sourcePath: sourcePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      initCropped(context, "assets/success.png");
    });

    return
      SafeArea(child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(controller.testText.value),
            Image.asset(
              "assets/success.png",
              fit: BoxFit.scaleDown,
              width: 40,
              height: 40,
            )
          ],
        ),
      ),
    ),);

  }

}