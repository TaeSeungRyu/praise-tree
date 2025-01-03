# 🌳 칭찬 나무 프로젝트

**칭찬 나무 프로젝트**는 어린이들이 멋진 활동을 하는 경우 부모님께 도장을 받는 앱입니다.
멋진 칭찬도장을 찍어 나무가 자랄 수 있게 도와주세요!

---

## 💡 기획 의도

칭찬나무를 매번 종이에 그리고 붙이는 것이 아닌, 디지털로 관리할 수 있는 방법을 찾다가 칭찬나무 프로젝트를 기획하게 되었습니다.
무료 앱으로 제작하여 많은 어린이들이 사용할 수 있도록 하였습니다.
따로 서버를 구축하지 않아서 지우면 데이터가 사라지는 단점이 있지만, 어린이들이 사용하기에는 적합한 앱이라고 생각합니다.

---

## 🛠️ 기술 스택

- **프론트엔드**: Flutter (Dart)
- **배포**: Google Play Store

---

## 개인정보처리방침

본 앱은 사용자의 개인정보를 수집하거나 저장하지 않습니다.
문의사항이 있을 경우 lts06069@naver.com으로 연락 바랍니다.
---

## 🚀 설치 및 실행

### 1. 클론하기
```bash
git clone https://github.com/TaeSeungRyu/praise-tree.git
cd praise-tree
```

### 2. 종속성 설치
```bash
flutter pub get
```

### 3. 앱 실행
```bash
flutter run
```

### 4. 앱 배포 방법 소개
```bash
1. 배포를 위해서 key를 생성 합니다.(keytool -genkey -v -keystore 배포경로/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key)
2. 생성된 키 값을 프로젝트의 android/app에 넣어줍니다.
3. 프로젝트의 android/app/build.gradle에 key 값을 넣어줍니다. 또한 각종 설정을 해줍니다.(key.properties 파일을 생성하여 key 값을 관리하는 것을 추천합니다.)
4. flutter build appbundle을 통해 appbundle을 생성합니다.
5. 생성된 appbundle을 Google Play Store에 업로드 합니다.
```
