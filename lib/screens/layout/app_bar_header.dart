import 'package:flutter/material.dart';

/// 앱바 헤더 위젯 입니다.
PreferredSizeWidget appBarHeader(String title, Function action) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(kToolbarHeight),
    child: Container(
      decoration: const BoxDecoration(
        color:  Color.fromRGBO(79, 195, 244, 1),// AppBar 배경색
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(79, 105, 244,0.2),// 그림자 색상
            spreadRadius: 0,
            blurRadius:4,
            offset:  Offset(0,4), // 그림자가 아래로 향하게 설정
          ),
        ],
      ),
      child: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        // 배경색은 BoxDecoration에서 처리
        elevation: 0,
        // 기본 그림자 제거
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () {
              action();
                        },
          ),
        ],
      ),
    ),
  );
}