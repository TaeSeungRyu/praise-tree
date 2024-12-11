import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  static AppController get to => Get.find();

  RxString testText = 'asdf1234'.obs;
}