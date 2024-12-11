
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';

class Setting extends GetView<AppController> {
  const Setting({super.key});

  static const routeName = "/setting";

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("setting"),
              Text(controller.testText.value),
            ],
          ),
        ),
      ),);

  }

}