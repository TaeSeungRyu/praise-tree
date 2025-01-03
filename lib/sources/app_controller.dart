import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_heart_son/const/const.dart';
import 'package:my_heart_son/screens/component/modals.dart';

import 'package:my_heart_son/utils/data_storage.dart';
import 'package:my_heart_son/screens/tree.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app_vo.dart';

///앱 컨트롤러 클래스 입니다.
///앱의 전반적인 상태를 관리합니다.
///도메인별 컨트롤러를 분리하여 사용해야 하나 간단하게 하나로 관리합니다.( 당연히 분리해야 합니다. :-) )
class AppController extends GetxController with WidgetsBindingObserver {
  static AppController get to => Get.find();

  RxString splashImagePath =
      'assets/icons/splash-background.png'.obs; //스플래시 이미지
  RxString treePath = 'assets/icons/tree.png'.obs; //트리 이미지
  RxString applePath = 'assets/icons/apple.png'.obs; //사과 이미지
  Rx<File> appleSavedPath =
      File("").obs; //저장된 사과 이미지(해당 이미지가 있으면 applePath는 무시됩니다.)
  RxString finishPath = 'assets/icons/finish.png'.obs; //도장을 전부 찍은 경우 완료 이미지
  RxBool isShowMainText = false.obs; //메인 텍스트를 보여줄지 여부
  RxString appMainText = '우리아이 칭찬나무'.obs; //메인 텍스트
  TextEditingController appMainTextController =
      TextEditingController(); //텍스트 컨트롤러(설정에서 사용)
  Rx<Color> splashColor = Colors.white.obs; //스플래시 색상
  final Rx<Offset> center = const Offset(200, 300).obs; //디바이스의 중앙

  RxList<TreeVo> treeSavedDataList =
      <TreeVo>[].obs; //저장된 데이터 리스트(처음 Storage에서 데이터를 가져와 적용 합니다.)
  RxList<GlobalKey> treeKeyList = <GlobalKey>[].obs; //페이지 키 리스트
  PageController pageController = PageController(); //페이지 컨트롤러
  RxInt currentPage = 0.obs; //현재 페이지

  final int maxAppleCount = 10; //사과의 최대 갯수
  RxList<MarkPositionVo> currentPositionList =
      <MarkPositionVo>[].obs; //현재 페이지의 사과 위치 리스트

  RxString treeBottomText =
      "오늘은 ${DateFormat('yyyy년 MM월 dd일').format(DateTime.now())}에요!"
          .obs; //트리 하단 텍스트
  RxDouble treeBottomTextLeftPosition = 0.0.obs; //트리 하단 텍스트 위치
  Rx<MarkPositionVo> allowMarkPosition =
      MarkPositionVo(x: 0, y: 0).obs; //사과를 찍을 수 있는 화면 위치
  RxString missionCompleteMessage =
      '도장을 다 모았어요!\n다음페이지로 이동하세요!'.obs; //미션 완료 메시지

  CustomImageCropController cropController =
      CustomImageCropController(); //이미지 자르기 컨트롤러
  Rx<File> previewImage = File("").obs; //미리보기 이미지
  Rx<File> cropedImage = File("").obs; //자른 이미지

  ///저장소 권한을 요청합니다.(안드로이드 버전이 33 이하일 경우)
  Future<void> requestStoragePermission(BuildContext context) async {
    //안드로이드가 아니거나 버전이 33 이상이면 권한 요청을 하지 않는다.
    if (!Platform.isAndroid) return;
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) return;
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
      if (status.isGranted) {
        Get.snackbar(
          '저장소 권한',
          '저장소 권한이 허용 되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          '저장소 권한',
          '저장소 권한이 거부 되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
      }
    }
    return;
  }

  ///splash에서 4초 후에 tree로 이동합니다.
  Future<void> runTimer() async {
    await Future.delayed(const Duration(seconds: 4));
    Get.offNamed(Tree.routeName);
  }

  ///스타일 설정 함수, 이미지의 중앙 위치를 계산합니다.
  void initTreeConfigurationStyle(context) {
    //화면 설정
    final screenSize = MediaQuery.of(context).size;
    center.value = Offset(screenSize.width / 2, screenSize.height / 2);
    treeBottomTextLeftPosition.value =
        center.value.dx - (treeBottomText.value.length * 5);
    if (treeKeyList.isNotEmpty &&
        treeKeyList[currentPage.value] != null &&
        treeKeyList[currentPage.value]!.currentContext != null) {
      final RenderBox renderBox = treeKeyList[currentPage.value]!
          .currentContext!
          .findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero); // 위치 (Global 좌표)
      allowMarkPosition.value = MarkPositionVo(
        x: position.dx,
        y: position.dy,
        width: renderBox.size.width,
        height: renderBox.size.height,
      );
    }
  }

  ///설명모달 및 비밀번호 모달 실행여부 함수 입니다.
  void initTreeConfiguration(context) {
    DataStorage.get(Constants.passWordData.value).then((value) {
      if (value.isEmpty) {
        explainSlideStyleBox(context, () {
          runKeyPadModal(context, () {}, isNew: true);
        });
      }
    });
    if (treeSavedDataList.isNotEmpty) {
      onPageChanged(context, treeSavedDataList.length - 1);
    }
  }

  ///페이지 변경 함수
  void onPageChanged(BuildContext context, int index) {
    initTreeConfigurationStyle(context);
    if (index == -1) {
      index = treeSavedDataList.length - 1;
    }
    currentPage.value = index;
    currentPositionList.clear();
    currentPositionList.addAll(treeSavedDataList[index].positionList);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pageController.jumpToPage(index);
    });
  }

  ///왼쪽으로 페이지 이동 함수
  void leftMovePage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  ///오른쪽으로 페이지 이동 함수
  void rightMovePage() {
    if (currentPage.value < treeSavedDataList.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  ///사과 추가 내부 함수
  void _addAppleInnerFunction(position) {
    final storageKey = Constants.savedDataList.value;
    //이미지를 허용된 위치에서만 클릭할 수 있게 합니다.
    //scale을 적용하였기에 0.9를 곱해줍니다.
    var vo = MarkPositionVo(
      x: position.dx * 0.9,
      y: position.dy * 0.9,
    );
    currentPositionList.add(vo);
    treeSavedDataList.last.positionList.add(vo);
    //저장소에 데이터를 저장합니다.
    DataStorage.get(storageKey).then((value) {
      if (value.isEmpty) {
        DataStorage.put(
          key: storageKey,
          value: [treeSavedDataList.last.toString()].toString(),
        );
      } else {
        var savedDataList = json.decode(value).cast<dynamic>();
        var lastData = TreeVo.fromJson(savedDataList.last);
        lastData.positionList.add(vo);
        savedDataList.removeLast();
        savedDataList.add(lastData.toJson());
        DataStorage.put(
          key: storageKey,
          value: json.encode(savedDataList),
        );
      }
    });
    //사과의 최대 갯수를 넘어가면 다음 페이지로 넘어갑니다.
    if (treeSavedDataList.last.positionList.length >= maxAppleCount) {
      final day = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());
      treeSavedDataList.last.finishedDate = day;
      treeSavedDataList.add(TreeVo(positionList: [], finishedDate: ""));
      treeKeyList.add(GlobalKey());
      DataStorage.get(storageKey).then((value) {
        var savedDataList = json.decode(value).cast<dynamic>();
        var lastData = TreeVo.fromJson(savedDataList.last);
        lastData.positionList.add(vo);
        lastData.finishedDate = day;
        savedDataList.removeLast();
        savedDataList.add(lastData.toJson());
        savedDataList.add(TreeVo(positionList: [], finishedDate: ""));
        DataStorage.put(key: storageKey, value: json.encode(savedDataList));
      });
      return;
    }
  }

  ///사과를 추가합니다.
  void addApple(TapDownDetails details, BuildContext context) {
    final position = details.localPosition;
    var minX = allowMarkPosition.value.width * 0.1;
    var maxX = allowMarkPosition.value.width * 0.9;
    var minY = allowMarkPosition.value.height * 0.3;
    var maxY = allowMarkPosition.value.height * 0.9;
    if (position.dx < minX ||
        position.dx > maxX ||
        position.dy < minY ||
        position.dy > maxY) {
      return;
    }
    //사과의 최대 갯수를 넘어가면 리턴합니다.
    if (currentPositionList.length >= maxAppleCount) {
      return;
    }
    //비밀번호 모달 실행
    runKeyPadModal(context, () {
      _addAppleInnerFunction(position);
    }, isNew: false);
  }

  ///이름 변경 함수
  void changeAppMainText(BuildContext context) {
    confirmBox(context, "확인", "이름을 변경 하시겠습니까?", () {
      appMainText.value = appMainTextController.text;
      DataStorage.put(
        key: Constants.appMainText.value,
        value: appMainText.value,
      );
      Get.snackbar(
        '변경 완료',
        '이름이 변경 되었습니다.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
      );
    });
  }

  ///이미지를 선택합니다.
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var isRemoveCropedImage = await cropedImage.value.exists();
      if (isRemoveCropedImage == true) {
        cropedImage.value.deleteSync();
        cropedImage.refresh();
      }
      previewImage.value = File(image.path);
      previewImage.refresh();
      cropController.reset();
    }
  }

  ///이미지를 자릅니다.
  Future<void> cropImage(BuildContext context) async {
    Get.snackbar(
      '진행',
      '이미지 자르기작업을 시작합니다.\n시간이좀 걸려요!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blueAccent,
      colorText: Colors.white,
      animationDuration: const Duration(seconds: 1),
    );
    var image = await cropController.onCropImage();
    if (image != null) {
      var randomString = Random().nextInt(10000);
      cropedImage.value =
          await File('${previewImage.value.path}_cropped_$randomString.png')
              .writeAsBytes(image.bytes);
      cropedImage.refresh();
      cropController.reset();
      previewImage.value = File("");
      previewImage.refresh();
    }
  }

  ///자른 이미지를 저장합니다.
  void saveImage(BuildContext context) async {
    if (cropedImage.value.existsSync()) {
      var randomString = Random().nextInt(10000);
      var path = await getApplicationDocumentsDirectory();
      final result = await cropedImage.value
          .copy('${path.path}/cropped_$randomString.png');
      try {
        DataStorage.put(
          key: Constants.cropImagePaths.value,
          value: '${path.path}/cropped_$randomString.png',
        );
        appleSavedPath.value = result;
        Get.snackbar(
          '저장 완료',
          '이미지가 저장되었습니다.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
          animationDuration: const Duration(seconds: 1),
        );
        Get.back(closeOverlays: true);
      } catch (e) {
        debugPrint("errrr: $result");
      }
    }
  }

  ///저장된 이미지를 삭제합니다.
  void resetStampImage(BuildContext context) {
    confirmBox(context, "초기화", "원래 사진으로 되돌아가시겠습니까?", () {
      previewImage.value = File("");
      cropedImage.value = File("");
      appleSavedPath.value = File("");
      previewImage.refresh();
      cropedImage.refresh();
      appleSavedPath.refresh();
      DataStorage.remove(Constants.cropImagePaths.value);
      Get.snackbar(
        '완료',
        '기존 이미지로 초기화 하였습니다!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blueAccent,
        colorText: Colors.white,
      );
    });
  }

  ///비밀번호 초기화 함수
  void changePassword(BuildContext context) {
    runKeyPadModal(context, () {
      runKeyPadModal(context, () {
        Get.snackbar(
          '완료',
          '비밀번호가 변경 되었습니다!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blueAccent,
          colorText: Colors.white,
        );
      }, isNew: true, title: '변경할 비밀번호를 입력해주세요.');
    }, isNew: false);
  }

  ///컨트롤러 초기화 함수
  @override
  void onInit() async {
    super.onInit();
    //메인 이미지를 먼저 불러와 캐시되게 합니다.
    //먼저 불러오게되면 이미지의 위치와 크기, 좌표값이 나오게 됩니다.
    AssetImage(treePath.value)
        .resolve(
          const ImageConfiguration(),
        )
        .addListener(
          ImageStreamListener(
            (ImageInfo info, bool synchronousCall) {},
            onError: (dynamic error, StackTrace? stackTrace) {},
          ),
        );
    //저장된 데이터 불러와서 기본 데이터로 세팅 합니다.
    DataStorage.get(Constants.savedDataList.value).then((value) {
      if (value.isNotEmpty) {
        var savedDataList = json.decode(value).cast<dynamic>();
        treeSavedDataList.clear();
        treeKeyList.clear();
        savedDataList.forEach((element) {
          treeSavedDataList.add(TreeVo.fromJson(element));
          treeKeyList.add(GlobalKey());
        });
      } else {
        debugPrint("저장된 데이터가 없습니다.");
        treeSavedDataList.add(TreeVo(positionList: [], finishedDate: ""));
        treeKeyList.add(GlobalKey());
      }
    });

    //페이지 변경시 현재 페이지의 사과 위치 리스트를 변경합니다.
    pageController.addListener(() {
      currentPositionList.clear();
      currentPositionList
          .addAll(treeSavedDataList[currentPage.value].positionList);
    });

    //저장된 이름을 불러옵니다.
    DataStorage.get(Constants.appMainText.value).then((value) {
      if (value.isNotEmpty) {
        appMainText.value = value;
      }
      appMainTextController.text = appMainText.value;
      isShowMainText.value = true;
    });

    //저장된 이미지를 불러옵니다.
    DataStorage.get(Constants.cropImagePaths.value).then((contentUri) async {
      if (contentUri.isNotEmpty) {
        final file = File(contentUri);
        appleSavedPath.value = file;
      }
    });
    //테스트 코드
    //DataStorage.remove(Constants.passWordData.value);
    //DataStorage.remove(Constants.savedDataList.value);
  }
}
