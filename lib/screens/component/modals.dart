import 'package:flutter/material.dart';

confirmBox(BuildContext context, String title, String content,
    Function confirmFunction, Function cancelFunction) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        iconColor: Colors.lightBlue,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              cancelFunction();
              Navigator.pop(context, '취소');
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              confirmFunction();
              Navigator.pop(context, '확인');
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}

explainSlideStyleBox (BuildContext context, String content, Function confirmFunction) {
  //              confirmFunction();
  //               Navigator.pop(context, '확인');
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.3),
        child: Column(
          children: [
            Text(content),
            TextButton(
              onPressed: () {
                confirmFunction();
                Navigator.pop(context, '확인');
              },
              child: const Text('확인'),
            ),
          ],
        ),

      );
    },
  );
}