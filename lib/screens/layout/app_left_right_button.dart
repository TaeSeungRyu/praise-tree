
import 'package:flutter/material.dart';
import 'package:my_heart_son/utils/display_util.dart';

Widget appLeftRightButton(
    BuildContext context,
    bool isLeft,
    Function action,
    ) {
  return Positioned(
    left: isLeft ? 10 : null,
    right: isLeft ? null : 10,
    width: 50,
    height: 50,
    top: MediaQuery.of(context).size.height / 2 - 60,
    child: IconButton(
      icon: isLeft
          ? Icon(
        Icons.arrow_circle_left_outlined,
        color: Colors.lightBlue,
        size: 35.ratio,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(2, 1),
            blurRadius: 2,
          ),
        ],
      )
          : Icon(
        Icons.arrow_circle_right_outlined,
        color: Colors.lightBlue,
        size: 35.ratio,
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            offset: const Offset(2, 1),
            blurRadius: 2,
          ),
        ],
      ),
      onPressed: () {
        action();
      },
    ),
  );
}