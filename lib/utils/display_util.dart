import 'package:flutter/material.dart';

extension IntExtension on int {
  double get ratio => this * DisplayUtil.ratio;
}

extension DoubleExtension on double {
  double get ratio => this * DisplayUtil.ratio;
}

class DisplayUtil {
  static late BuildContext context;
  static late double height;
  static late double width;
  static late double ratio;
  static double displayHeight = MediaQuery.of(context).size.height;
  static double displayWidth = MediaQuery.of(context).size.width;
  static late bool vertical;

  static double get hhh => displayHeight;
  static double get www => displayWidth;

  static double get statusBarHeight => MediaQuery.of(context).viewPadding.top;

  static double get padding => vertical ? (displayHeight - height.ratio) / 2 : (displayWidth - width.ratio) / 2;

  static void init(buildContext, {required double designHeight, required double designWidth}) {
    context = buildContext;
    height = designHeight;
    width = designWidth;
    ratio = designHeight > designWidth ? displayWidth / designWidth : displayHeight / designHeight;
    vertical = designHeight > designWidth;
  }

  static void initVertical(buildContext, {required double designHeight, required double designWidth}) {
    context = buildContext;
    height = designHeight;
    width = designWidth;
    displayWidth = MediaQuery.of(buildContext).size.width;
    ratio = displayWidth / designWidth;
    vertical = true;
  }

  static void initHorizontal(buildContext, {required double designHeight, required double designWidth}) {
    context = buildContext;
    height = designHeight;
    width = designWidth;
    displayHeight = MediaQuery.of(buildContext).size.height;
    ratio = displayHeight / designHeight;
    vertical = false;
  }


}
