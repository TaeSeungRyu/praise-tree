import 'dart:io';
import 'dart:math';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_heart_son/const/const.dart';
import 'package:my_heart_son/screens/component/data_storage.dart';
import 'package:my_heart_son/screens/tree.dart';

import 'app_vo.dart';

class AppController extends GetxController with WidgetsBindingObserver {
  static AppController get to => Get.find();

  RxString splashImagePath = 'assets/icons/splash-background.png'.obs;
  RxString treePath = 'assets/icons/tree.png'.obs;
  RxString applePath = 'assets/icons/apple.png'.obs;
  RxString finishPath = 'assets/icons/finish.png'.obs;
  RxString appMainText = 'treeeeeee'.obs;

  Rx<Color> splashColor = Colors.white.obs;
  CustomImageCropController cropController = CustomImageCropController();
  Rx<File> previewImage = File("").obs; //미리보기 이미지
  Rx<File> cropedImage = File("").obs; //자른 이미지
  final Rx<Offset> center = const Offset(200, 300).obs; //디바이스의 중앙

  ///splash에서 4초 후에 tree로 이동합니다.
  Future<void> runTimer() async {
    await Future.delayed(const Duration(seconds: 4));
    Get.offNamed(Tree.routeName);
  }

  ///TODO : 이미지를 선택합니다.(도장 이미지 변경)
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint("image path: ${image.path}");
      var isRemoveCropedImage = await cropedImage?.value.exists();
      if (isRemoveCropedImage == true) {
        cropedImage?.value?.deleteSync();
        cropedImage?.refresh();
      }
      previewImage.value = File(image.path);
      previewImage.refresh();
    }
  }

  ///이미지를 자릅니다.
  Future<void> cropImage(BuildContext context) async {
    var image = await cropController.onCropImage();
    if (image != null) {
      debugPrint("image: $image");
      var randomString = Random().nextInt(10000);
      cropedImage.value =
          await File('${previewImage!.value!.path}_cropped_$randomString.png')
              .writeAsBytes(image.bytes);
      cropedImage.refresh();
    }
  }

  //TODO : 키 값을 스토리지에 저장하고, 스토리지에서 값을 가져오기
  RxList<TreeVo> treeSavedDataList = <TreeVo>[].obs;
  RxList<GlobalKey> treeKeyList = <GlobalKey>[].obs;
  PageController pageController = PageController();
  RxInt currentPage = 0.obs;

  final int maxAppleCount = 3;
  RxList<MarkPositionVo> currentPositionList = <MarkPositionVo>[].obs;
  RxString treeBottomText =
      "오늘은 ${DateFormat('yyyy년 MM월 dd일').format(DateTime.now())}에요!".obs;
  RxDouble treeBottomTextLeftPosition = 0.0.obs;
  Rx<MarkPositionVo> allowMarkPosition = MarkPositionVo(x: 0, y: 0).obs;
  RxString missionCompleteMessage = '도장을 다 모았어요!\n다음페이지로 이동하세요!'.obs;

  ///이미지의 중앙 위치를 계산합니다.
  void initTreeConfiguration(context) {
    //화면 설정
    final screenSize = MediaQuery.of(context).size;
    center.value = Offset(screenSize.width / 2, screenSize.height / 2);
    treeBottomTextLeftPosition.value =  center.value.dx - (treeBottomText.value.length * 5);
    if (treeKeyList[currentPage.value] != null &&
        treeKeyList[currentPage.value]?.currentContext != null) {
      final RenderBox renderBox = treeKeyList[currentPage.value]
          .currentContext
          ?.findRenderObject() as RenderBox;

      final position = renderBox.localToGlobal(Offset.zero); // 위치 (Global 좌표)
      allowMarkPosition.value = MarkPositionVo(
        x: position.dx,
        y: position.dy,
        width: renderBox.size.width,
        height: renderBox.size.height,
      );
    }
    //TODO : 설명 모달 시작여부 판별
  }

  void onPageChanged(int index) {
    initTreeConfiguration(Get.context!);
    currentPage.value = index;
    pageController.jumpToPage(index);

    currentPositionList.clear();
    currentPositionList.addAll(treeSavedDataList[index].positionList);
  }

  ///사과를 추가합니다.
  void addApple(TapDownDetails details) {
    //이미지를 허용된 위치에서만 클릭할 수 있게 합니다.
    final position = details.localPosition;
    var minX = allowMarkPosition.value.width * 0.1;
    var maxX = allowMarkPosition.value.width * 0.9;
    var minY = allowMarkPosition.value.height * 0.3;
    var maxY = allowMarkPosition.value.height * 0.9;
    if (position.dx < minX || position.dx > maxX) {
      return;
    }
    if (position.dy < minY || position.dy > maxY) {
      return;
    }

    //사과의 최대 갯수를 넘어가면 리턴합니다.
    if (currentPositionList.length >= maxAppleCount) {
      return;
    }
    //scale을 적용하였기에 0.9를 곱해줍니다.
    var vo = MarkPositionVo(
      x: position.dx * 0.9,
      y: position.dy * 0.9,
    );
    currentPositionList.add(vo);
    treeSavedDataList.last.positionList.add(vo);

    //사과의 최대 갯수를 넘어가면 다음 페이지로 넘어갑니다.
    if (treeSavedDataList.last.positionList.length >= maxAppleCount) {
      treeSavedDataList.last.finishedDate =
          DateFormat('yyyy년 MM월 dd일').format(DateTime.now());
      treeSavedDataList.add(TreeVo(positionList: [], finishedDate: ""));
      treeKeyList.add(GlobalKey());
      //TODO : 여기에 로컬 저장소..
      return;
    }
  }

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

    //최초 로그인여부를 저장소를 통해 확인합니다.
    var isNotFirstAccess =
        await DataStorage.get(Constants.isNotFirstAccess.value);
    //TODO : 여기에 설명하는 모달이 실행 됩니다.
    if (isNotFirstAccess == null) {}

    //TODO : 여기에서 저장된 데이터 불러와서 기본 데이터로 세팅
    TreeVo treeVo = TreeVo(
      positionList: [],
      finishedDate: "",
    );
    treeSavedDataList.add(treeVo);
    treeKeyList.add(GlobalKey());
    pageController.addListener(() {
      currentPositionList.clear();
      currentPositionList
          .addAll(treeSavedDataList[currentPage.value].positionList);
    });
  }
}
