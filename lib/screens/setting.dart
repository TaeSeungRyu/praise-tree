import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_heart_son/screens/image_selector.dart';
import 'package:my_heart_son/sources/app_controller.dart';
import 'package:my_heart_son/utils/display_util.dart';

class Setting extends GetView<AppController> {
  const Setting({super.key});

  static const routeName = "/setting";

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SafeArea(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: const Color.fromRGBO(79, 195, 247, 0.7),
              height: Get.height,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        '환경 설정',
                        style: TextStyle(
                          fontSize: 25.ratio,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        controller.treePath.value,
                        fit: BoxFit.cover,
                        scale: 3,
                      ),
                    ),
                    const Divider(
                      color: Color.fromRGBO(0, 0, 0, 0.2), // 선 색상
                      thickness: 1, // 선 두께
                      height: 30, // 선 높이
                    ),
                    Text(
                      "1. 앱 이름 변경",
                      style: TextStyle(
                        fontSize: 20.ratio,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 7.ratio),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: TextField(
                            maxLength: 12,
                            controller: controller.appMainTextController,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: '이름 입력',
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // 버튼 동작 추가
                                    controller.changeAppMainText(context);
                                  },
                                  child: const Text('변경'),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Text(
                        "* 설명 : 앱 이름을 바꿀 수 있습니다(아이콘 이름 제외).",
                        style: TextStyle(
                          fontSize: 12.ratio,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.ratio),
                    Text(
                      "2. 도장 사진 변경",
                      style: TextStyle(
                        fontSize: 20.ratio,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Get.toNamed(ImageSelector.routeName);
                              },
                              child: const Text('사진 변경'),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                controller.resetStampImage(context);
                              },
                              child: const Text('초기화'),
                            ),
                          ],
                        )
                    ),
                    Center(
                      child: Text(
                        "* 설명 : 도장 사진을 바꿀 수 있습니다.",
                        style: TextStyle(
                          fontSize: 12.ratio,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.ratio),
                    Text(
                      "3. 도장 비밀번호 변경",
                      style: TextStyle(
                        fontSize: 20.ratio,
                        color: Colors.white,
                      ),
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.changePassword(context);
                        },
                        child: const Text('비밀번호 변경'),
                      ),
                    ),
                    Center(
                      child: Text(
                        "* 설명 : 비밀번호를 바꿀 수 있습니다.",
                        style: TextStyle(
                          fontSize: 12.ratio,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    SizedBox(height: 55.ratio),
                    Text(
                      "이 앱은 어떠한 정보도 수집하지 않습니다.\n또한 인터넷 사용, 광고, 결제 기능이 없습니다.\n앱을 제거하거나 초기화하면 모든 데이터가 삭제됩니다.",
                      style: TextStyle(
                        fontSize: 14.ratio,
                        color: const Color.fromRGBO(0, 0, 0, 0.35),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
