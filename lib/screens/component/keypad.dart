import 'package:flutter/material.dart';
import 'package:my_heart_son/utils/display_util.dart';

Widget keyPadButton({required String keyText, required Function() onKeyTap}) {
  return Expanded(
    child: TextButton(
      onPressed: onKeyTap,
      child: Text(
        keyText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.ratio,
        ),
      ),
    ),
  );
}

Widget numberKeyPad(BuildContext context, Function(String) press) {
  // 키패드에 표시할 텍스트 배열
  final keys = [
    ['1', '2', '3'],
    ['4', '5', '6'],
    ['7', '8', '9'],
    ['', '0', '<'],
  ];

  return Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.6),
      border: Border.all(
        color: Colors.black.withOpacity(0.6),
        width: 1,
      ),
      borderRadius: BorderRadius.circular(7.ratio),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: const Offset(1, 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.map((row) {
        return Row(
          children: row.map((keyText) {
            return keyPadButton(
              keyText: keyText,
              onKeyTap: () => press(keyText),
            );
          }).toList(),
        );
      }).toList(),
    ),
  );
}
