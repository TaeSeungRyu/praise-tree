import 'package:flutter/material.dart';
import 'package:my_heart_son/const/const.dart';
import 'package:my_heart_son/screens/component/keypad.dart';
import 'package:my_heart_son/utils/data_storage.dart';

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
              if(cancelFunction != null) {
                cancelFunction();
              }
              Navigator.pop(context, '취소');
            },
            child: const Text('취소'),
          ),
          TextButton(
            onPressed: () {
              if(confirmFunction != null) {
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

const explainSliderContents = [
  "첫번째 설명",
  "두번째 설명",
  "세번째 설명",
  "네번째 설명",
  "다섯번째 설명",
];

var textStyle = const TextStyle(
  color: Colors.white,
  fontSize: 20,
);

explainSlideStyleBox(BuildContext context, Function confirmFunction) {
  var pageController = PageController();
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
                      Text(
                        explainSliderContents[index],
                        style: textStyle,
                      ),
                      index == explainSliderContents.length - 1
                          ? TextButton(
                              onPressed: () {
                                Navigator.pop(context, '확인');
                                confirmFunction();
                              },
                              child: Text(
                                '확인',
                                style: textStyle,
                              ),
                            )
                          : TextButton(
                              onPressed: () {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeIn,
                                );
                              },
                              child: Text(
                                '다음',
                                style: textStyle,
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
  const KeyPadModalWidget(this.context, this.confirmFunction,this.isNew, {super.key});
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
    //TODO : 신규비밀번호인지 아니면 확인비밀번호인지 구분해야함.
    //TODO : 저장소에서 비밀번호를 가져와서 비교해야함.
    DataStorage.get(Constants.passWordData.value).then((value) {
      savedPassword = value;
    });

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '비밀번호를 입력해주세요.',
            style: textStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...inputNumberArray.map((e) => Text(e, style: textStyle)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10),
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
                              value: firstPassword,);
                          Navigator.pop(context, '확인');
                          widget.confirmFunction();
                        } else {
                          firstPassword = "";
                          inputNumberArray.clear();
                          inputLength = 0;
                          confirmBox(context, '비밀번호가 일치하지 않습니다.', '다시 입력해주세요.',);
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
          // TextButton(
          //   onPressed: () {
          //     Navigator.pop(context, '확인');
          //     widget.confirmFunction();
          //   },
          //   child: Text(
          //     '확인',
          //     style: textStyle,
          //   ),
          // ),
        ],
      ),
    );
  }
}

runKeyPadModal(BuildContext context, Function confirmFunction, {isNew = false}) {
  return showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (BuildContext context) {
      return Dialog.fullscreen(
        backgroundColor: Colors.black.withOpacity(0.35),
        child: PopScope(
          canPop: isNew ? false : true,
          onPopInvoked: (src) {},
          child: KeyPadModalWidget(context, confirmFunction, isNew),
        ),
      );
    },
  );
}
