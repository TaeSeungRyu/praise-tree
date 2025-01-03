import 'dart:async';
import 'package:flutter/services.dart';

class ContentUriHelper {
  static const MethodChannel _channel = MethodChannel('content.uri.channel');

  static Future<String?> getFilePathFromUri(String uri) async {
    try {
      final result = await _channel.invokeMethod('getFileFromContentUri', {"uri": uri});
      return result as String?;
    } catch (e) {
      print("오류 발생: $e");
      return null;
    }
  }
}