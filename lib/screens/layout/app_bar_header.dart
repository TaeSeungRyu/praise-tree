import 'package:flutter/material.dart';

/// 앱바 헤더 위젯 입니다.
PreferredSizeWidget appBarHeader(String title, Function action) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue, // AppBar 배경색
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // 그림자 색상
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 4), // 그림자가 아래로 향하게 설정
          ),
        ],
      ),
      child: AppBar(
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        // 배경색은 BoxDecoration에서 처리
        elevation: 0,
        // 기본 그림자 제거
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              if(action != null) {
                action();
              }
            },
          ),
        ],
      ),
    ),
  );
}