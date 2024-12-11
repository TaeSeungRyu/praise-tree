
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:my_heart_son/screens/sources/app_controller.dart';

class Tree extends GetView<AppController> {
  const Tree({super.key});

  static const routeName = "/setting";

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("tree"),
              Text(controller.testText.value),
            ],
          ),
        ),
      ),);

  }

}