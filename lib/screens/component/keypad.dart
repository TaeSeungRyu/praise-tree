import 'package:flutter/material.dart';
import 'package:my_heart_son/utils/display_util.dart';

Widget keyPadButton({required String keyText, required Function() onKeyTap}) {
  return Expanded(
    child: TextButton(
      onPressed: () {
        onKeyTap();
      },
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
  return Container(
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      border: Border.all(
        color: Colors.black.withOpacity(0.7),
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
      children: <Widget>[
        Row(
          children: <Widget>[
            keyPadButton(
              keyText: '1',
              onKeyTap: () {
                press('1');
              },
            ),
            keyPadButton(
              keyText: '2',
              onKeyTap: () {
                press('2');
              },
            ),
            keyPadButton(
              keyText: '3',
              onKeyTap: () {
                press('3');
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            keyPadButton(
              keyText: '4',
              onKeyTap: () {
                press('4');
              },
            ),
            keyPadButton(
              keyText: '5',
              onKeyTap: () {
                press('5');
              },
            ),
            keyPadButton(
              keyText: '6',
              onKeyTap: () {
                press('6');
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            keyPadButton(
              keyText: '7',
              onKeyTap: () {
                press('7');
              },
            ),
            keyPadButton(
              keyText: '8',
              onKeyTap: () {
                press('8');
              },
            ),
            keyPadButton(
              keyText: '9',
              onKeyTap: () {
                press('9');
              },
            ),
          ],
        ),
        Row(
          children: <Widget>[
            keyPadButton(
              keyText: '',
              onKeyTap: () {
                press('');
              },
            ),
            keyPadButton(
              keyText: '0',
              onKeyTap: () {
                press('0');
              },
            ),
            keyPadButton(
              keyText: '<',
              onKeyTap: () {
                press('<');
              },
            ),
          ],
        ),
      ],
    ),
  );
}
