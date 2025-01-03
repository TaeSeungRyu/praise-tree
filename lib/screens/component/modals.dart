import 'package:flutter/material.dart';
import 'package:my_heart_son/const/const.dart';
import 'package:my_heart_son/screens/component/keypad.dart';
import 'package:my_heart_son/utils/data_storage.dart';
import 'package:my_heart_son/utils/display_util.dart';

confirmBox(BuildContext context, String title, String content,
    [Function? confirmFunction, Function? cancelFunction]) {
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
              if (cancelFunction != null) {
                cancelFunction();
              }
              Navigator.pop(context, '취소');
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if (confirmFunction != null) {
                confirmFunction();
              }
              Navigator.pop(context, '확인');
            },
            child: const Text('확인'),
          ),
        ],
      );
    },
  );
}
/**
우리아이 칭찬나무 앱 입니다!
나무를 클릭하여 도장을 찍어주세요.
도장은 최대 10개까지 찍을 수 있습니다.
도장을 다 찍으면 다음 페이지가 만들어 집니다! 다음페이지에서도 도장을 찍어주세요.

설정 화면에서 각종 설정을 할 수 있습니다.
앱 이름, 도장 및 비밀번호 변경 등이 가능합니다.
도장을 찍기 위해서 초기 비밀번호 설정이 필요 합니다.
비밀번호는 4자리 숫자로 설정해주세요.

해당 앱은 인터넷, 위치정보, 저장공간 접근 등 특별한 기능을 일체 사용하지 않습니다.
이에 앱을 삭제하게 되면 모든 데이터가 삭제됩니다.
 * */
const explainSliderContents = [
  "우리아이 칭찬나무 앱 입니다.\n나무를 클릭하여 도장을 찍어주세요.\n도장은 최대 10개까지 찍을 수 있습니다.",
  "도장을 다 찍으면 다음 페이지가 만들어 집니다! \n다음페이지에서도 도장을 찍어주세요.",
  "설정 화면에서 각종 설정을 할 수 있습니다.\n앱 이름, 도장 및 비밀번호 변경 등이 가능합니다.",
  "도장을 찍기 위해서\n초기 비밀번호 설정이 필요 합니다.\n비밀번호는 4자리 숫자로 설정해주세요.",
  "해당 앱은 인터넷, 위치정보, 저장공간 접근 등\n특별한 기능을 일체 사용하지 않습니다.\n이에 앱을 삭제하게 되면 모든 데이터가 삭제됩니다.\n이제 비밀번호를 설정해주세요! 😁",
];

const explainSliderImages = [
  'assets/icons/explain1.png',
  'assets/icons/explain2.png',
  'assets/icons/explain3.png',
  'assets/icons/explain4.png',
  'assets/icons/explain5.png',
];

var textStyle = const TextStyle(
  color: Colors.white,
  fontSize: 16,
);

explainSlideStyleBox(BuildContext context, Function confirmFunction) {
  var pageController = PageController();
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.35),
        child: PopScope(
          canPop: false,
          onPopInvoked: (src) {},
          child: Center(
            child: PageView.builder(
              itemCount: explainSliderContents.length,
              controller: pageController,
              onPageChanged: (index) {},
              itemBuilder: (context, index) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      index != explainSliderContents.length - 1 ?
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.5), // 그림자 색상
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(3, 3), // 그림자 위치
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            explainSliderImages[index],
                            width: screenWidth * 0.6,
                            height: screenHeight * 0.5,
                            fit: BoxFit.fill,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      ) : Image.asset(
                        explainSliderImages[index],
                        width: screenWidth * 0.75,
                        height: screenHeight * 0.4,
                      ),
                      SizedBox(height: 15.ratio),
                      Text(
                        explainSliderContents[index],
                        style: textStyle,
                        textAlign: TextAlign.center,
                      ),
                      index == explainSliderContents.length - 1
                          ? TextButton(
                              onPressed: () {
                                Navigator.pop(context, '확인');
                                confirmFunction();
                              },
                              child: const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  '확인',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child:  Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Text(
                                  '다음 페이지로\n${index + 1}/${explainSliderContents.length}',
                                  style: const  TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class KeyPadModalWidget extends StatefulWidget {
  final BuildContext context;
  final Function confirmFunction;
  final bool isNew;
  final String title;

  const KeyPadModalWidget(
      this.context, this.confirmFunction, this.isNew, this.title,
      {super.key});

  @override
  KeyPadModalWidgetState createState() => KeyPadModalWidgetState();
}

class KeyPadModalWidgetState extends State<KeyPadModalWidget> {
  var pageController = PageController();
  var inputLength = 0;
  var inputNumberArray = List<String>.empty(growable: true);
  var maxPasswordLength = 4;
  var firstPassword = '';
  var secondPassword = '';
  var savedPassword = '';

  @override
  Widget build(BuildContext context) {
    DataStorage.get(Constants.passWordData.value).then((value) {
      savedPassword = value;
    });
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10.ratio),
          inputNumberArray.isEmpty
              ? SizedBox(height: 25.ratio)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ...inputNumberArray.map((e) => Text(e, style: textStyle)),
                  ],
                ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 40, right: 40),
            child: numberKeyPad(
              context,
              (textNumber) {
                setState(() {
                  if (textNumber == '<') {
                    if (inputLength > 0) {
                      inputNumberArray.removeLast();
                      inputLength--;
                    }
                    return;
                  }
                  inputNumberArray.add(textNumber);
                  if (inputLength < maxPasswordLength - 1) {
                    inputLength++;
                  } else {
                    var checkPassword = inputNumberArray.join();
                    if (widget.isNew) {
                      if (firstPassword.isEmpty) {
                        firstPassword = checkPassword;
                        inputNumberArray.clear();
                        inputLength = 0;
                        return;
                      } else {
                        secondPassword = checkPassword;
                        if (firstPassword == secondPassword) {
                          DataStorage.put(
                            key: Constants.passWordData.value,
                            value: firstPassword,
                          );
                          Navigator.pop(context, '확인');
                          widget.confirmFunction();
                        } else {
                          firstPassword = "";
                          inputNumberArray.clear();
                          inputLength = 0;
                          confirmBox(
                            context,
                            '비밀번호가 일치하지 않습니다.',
                            '다시 입력해주세요.',
                          );
                        }
                      }
                    } else {
                      if (savedPassword == checkPassword) {
                        Navigator.pop(context, '확인');
                        widget.confirmFunction();
                      } else {
                        confirmBox(context, '비밀번호가 일치하지 않습니다.', '다시 입력해주세요.');
                        checkPassword = "";
                        inputNumberArray.clear();
                        inputLength = 0;
                      }
                    }
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

runKeyPadModal(BuildContext context, Function confirmFunction,
    {isNew = false, title = '비밀번호를 입력해주세요.'}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.35),
        child: PopScope(
          canPop: isNew ? false : true,
          onPopInvoked: (src) {},
          child: KeyPadModalWidget(context, confirmFunction, isNew, title),
        ),
      );
    },
  );
}
