# naver_login_flutter
[![Build Status](https://img.shields.io/badge/pub-v3.0.0-success.svg)](https://pub.dev/packages/naver_login_flutter)
[![Build Status](https://img.shields.io/badge/naverAosSDK-v5.10.0-success.svg)](https://github.com/naver/naveridlogin-sdk-android)
[![Build Status](https://img.shields.io/badge/naverIosSDK-v5.0.0-success.svg)](https://github.com/naver/naveridlogin-sdk-ios-swift)
[![Build Status](https://img.shields.io/badge/build-passing-success.svg)](https://github.com/toyaji/naver_login_flutter)


Android와 iOS에서 네이버 로그인 SDK를 사용하기 위한 Flutter 플러그인입니다.

### 마이그레이션
- [from: `flutter_naver_login` to `naver_login_flutter` 3.0.0](#flutter_naver_login에서-naver_login_flutter-300으로-마이그레이션)
- [from: 2.1.0 이전 to: 2.1.0 이후](#마이그레이션-가이드)

## 📌 포크 배경 및 목적

이 레포지토리는 [yoonjaepark/flutter_naver_login](https://github.com/yoonjaepark/flutter_naver_login) 프로젝트의 **전용 포크(Fork)** 버전입니다. 원본 레포지토리와 독립적으로 관리되며, 패키지명을 `naver_login_flutter`로 변경하여 배포합니다.

### 왜 포크를 했나요?
* **2026년 CocoaPods 중단 대응**: Apple과 Flutter 생태계는 CocoaPods를 단계적으로 중단하고 있습니다(2026년 말까지 읽기 전용으로 전환). 이 플러그인은 iOS에서 **Swift Package Manager (SPM)** 네이티브 의존성 매핑을 완벽히 지원하도록 리팩토링 되었습니다.
* **Xcode 빌드 속도 최적화**: 대규모 프로젝트에서 CocoaPods와 SPM을 혼용하면 Xcode 증분 빌드 캐시가 무효화되어 빌드 병목(종종 170초 이상)이 발생합니다. 이 패키지를 완전히 SPM으로 마이그레이션함으로써 빌드 캐싱 기능을 복원합니다.
* **적극적인 커뮤니티 유지보수**: 원본 레포지토리의 업데이트가 멈춰있어, 최신 Flutter 안정 버전과 네이티브 SDK 리비전과의 호환성을 보장하기 위해 포크하여 관리합니다.

## 설치

### 1. 의존성 추가
`pubspec.yaml` 파일에 다음 내용을 추가하세요:

```yaml
dependencies:
  naver_login_flutter: ^3.0.0
```

### 2. 플랫폼 설정

#### Android
1. `android/app/src/main/res/values/strings.xml` 파일에 다음 내용을 추가하세요:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="client_id">[client_id]</string>
    <string name="client_secret">[client_secret]</string>
    <string name="client_name">[client_name]</string>
</resources>
```

2. `android/app/src/main/AndroidManifest.xml` 파일을 수정하세요:

```xml
<application
    android:name="io.flutter.app.FlutterApplication"
    android:label="your_app_name"
    android:icon="@mipmap/ic_launcher">
    <!-- 중요: task affinity가 필요하지 않은 경우 android:taskAffinity="" 라인을 제거하세요 -->
    <meta-data
        android:name="com.naver.sdk.clientId"
        android:value="@string/client_id" />
    <meta-data
        android:name="com.naver.sdk.clientSecret"
        android:value="@string/client_secret" />
    <meta-data
        android:name="com.naver.sdk.clientName"
        android:value="@string/client_name" />
</application>
```

> **참고**: AndroidManifest.xml에서 `android:taskAffinity=""` 라인이 보인다면, task affinity 기능이 특별히 필요한 경우가 아니라면 제거하세요.

3. MainActivity에서 `FlutterFragmentActivity`를 사용하세요:

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```

#### iOS
1. pods 설치:
```bash
cd ios
pod install
```

2. `ios/Runner/Info.plist` 파일을 수정하세요:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>[UrlScheme]</string>
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>naversearchapp</string>
    <string>naversearchthirdlogin</string>
</array>

<key>NidUrlScheme</key>
<string>[UrlScheme]</string>
<key>NidClientID</key>
<string>[ConsumerKey]</string>
<key>NidClientSecret</key>
<string>[ConsumerSecret]</string>
<key>NidAppName</key>
<string>[ServiceAppName]</string>
```

3. AppDelegate를 수정하세요:

```swift
import NidThirdPartyLogin

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (NidOAuth.shared.handleURL(url) == true) { // 네이버앱에서 전달된 url인 경우
          return true
        }
        
        // 다른 앱에서 들어온 url 처리
        return false
    }
}
```

## 마이그레이션 가이드

### `flutter_naver_login`에서 `naver_login_flutter` 3.0.0으로 마이그레이션

이 패키지는 기존 `flutter_naver_login`에서 **Swift Package Manager (SPM)** 전환 및 구조 개편을 위해 완전히 독립된 포크입니다. 기존 패키지를 사용하시던 분들은 다음 단계를 따라 마이그레이션 해야 합니다:

#### 1. `pubspec.yaml` 업데이트
기존 패키지를 지우고 새 패키지를 추가하세요:
```yaml
dependencies:
  # 제거: flutter_naver_login: ^2.x.x
  naver_login_flutter: ^3.0.0
```

#### 2. Dart Import 구문 변경
프로젝트 전체에서 기존 import를 찾아 새 패키지명으로 변경하세요:
```dart
// 기존
import 'package:flutter_naver_login/flutter_naver_login.dart';

// 변경 후
import 'package:naver_login_flutter/naver_login_flutter.dart';
```

#### 3. iOS 캐시 정리 (SPM 전환을 위한 필수 과정)
기존 패키지는 CocoaPods를 사용했고, 새 패키지는 SPM을 기본으로 사용합니다. 충돌을 방지하기 위해 **반드시** iOS 빌드 캐시를 초기화해야 합니다:
```bash
cd ios
pod deintegrate
rm -rf Podfile.lock Pods/
cd ..
flutter clean
flutter pub get
```

### iOS 마이그레이션 (2.1.0 이전 버전에서 2.1.0으로)

#### 1. Info.plist 수정

##### 2.1.0 이전 버전:

```xml

<key>naverServiceAppUrlScheme</key>
<string>[UrlScheme]</string>
<key>naverConsumerKey</key>
<string>[ConsumerKey]</string>
<key>naverConsumerSecret</key>
<string>[ConsumerSecret]</string>
<key>naverServiceAppName</key>
<string>[ServiceAppName]</string>
```

##### 2.1.0 이후 버전:

```xml

<key>NidUrlScheme</key>
<string>[UrlScheme]</string>
<key>NidClientID</key>
<string>[ConsumerKey]</string>
<key>NidClientSecret</key>
<string>[ConsumerSecret]</string>
<key>NidAppName</key>
<string>[ServiceAppName]</string>
```

#### 2. AppDelegate 수정

##### 2.1.0 이전 버전:

```swift
import NaverThirdPartyLogin

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var applicationResult = false
        if (!applicationResult) {
           applicationResult = NaverThirdPartyLoginConnection.getSharedInstance().application(app, open: url, options: options)
        }
        if (!applicationResult) {
           applicationResult = super.application(app, open: url, options: options)
        }
        return applicationResult
    }
}
```

##### 2.1.0 이후 버전:

```swift
import NidThirdPartyLogin

@UIApplicationMain
class AppDelegate: FlutterAppDelegate {
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (NidOAuth.shared.handleURL(url) == true) { // 네이버앱에서 전달된 url인 경우
          return true
        }
        
        // 다른 앱에서 들어온 url 처리
        return false
    }
}
```

## 사용 방법

### 타입

#### NaverLoginResult
```dart
class NaverLoginResult {
  final NaverLoginStatus status;  // 로그인 상태
  final NaverAccountResult? account;  // 계정 정보
}
```

#### NaverToken
```dart
class NaverToken {
  final String accessToken;  // 액세스 토큰
  final String refreshToken;  // 리프레시 토큰
  final String tokenType;  // 토큰 타입
  final String expiresAt;  // 만료 시간
  
  bool isValid();  // 토큰 유효성 검사
}
```

#### NaverAccountResult
```dart
class NaverAccountResult {
  final String id;  // 사용자 ID
  final String nickname;  // 닉네임
  final String name;  // 이름
  final String email;  // 이메일
  final String gender;  // 성별
  final String age;  // 나이
  final String birthday;  // 생일
  final String birthyear;  // 출생년도
  final String profileImage;  // 프로필 이미지
  final String mobile;  // 휴대폰 번호
  final String mobileE164;  // E164 형식의 휴대폰 번호
}
```

#### NaverLoginStatus
```dart
enum NaverLoginStatus {
  loggedIn,  // 로그인됨
  loggedOut,  // 로그아웃됨
  error  // 에러
}
```

### API 사용 예제

#### 로그인
```dart
try {
  final NaverLoginResult res = await FlutterNaverLogin.logIn();
  if (res.status == NaverLoginStatus.loggedIn) {
    // 로그인 성공
    final account = res.account;
    print('사용자 이름: ${account?.name}');
  }
} catch (error) {
  print('로그인 실패: $error');
}
```

#### 현재 액세스 토큰 가져오기
```dart
try {
  final NaverToken token = await FlutterNaverLogin.getCurrentAccessToken();
  if (token.isValid()) {
    print('액세스 토큰: ${token.accessToken}');
    print('리프레시 토큰: ${token.refreshToken}');
    print('토큰 타입: ${token.tokenType}');
    print('만료 시간: ${token.expiresAt}');
  }
} catch (error) {
  print('토큰 가져오기 실패: $error');
}
```

#### 현재 계정 정보 가져오기
```dart
try {
  final NaverAccountResult account = await FlutterNaverLogin.getCurrentAccount();
  print('사용자 이름: ${account.name}');
  print('이메일: ${account.email}');
  print('프로필 이미지: ${account.profileImage}');
} catch (error) {
  print('계정 정보 가져오기 실패: $error');
}
```

#### 로그아웃
```dart
try {
  final NaverLoginResult res = await FlutterNaverLogin.logOut();
  if (res.status == NaverLoginStatus.loggedOut) {
    // 로그아웃 성공
  }
} catch (error) {
  print('로그아웃 실패: $error');
}
```

#### 로그아웃 및 토큰 삭제
```dart
try {
  final NaverLoginResult res = await FlutterNaverLogin.logOutAndDeleteToken();
  if (res.status == NaverLoginStatus.loggedOut) {
    // 로그아웃 및 토큰 삭제 성공
  }
} catch (error) {
  print('로그아웃 및 토큰 삭제 실패: $error');
}
```

## 문제 해결

### iOS 문제

1. **CocoaPods 버전 에러**
   - 해결방법: Podfile에 최소 배포 타겟을 지정하세요:
   ```ruby
   platform :ios, '13.0' // https://github.com/naver/naveridlogin-sdk-ios-swift 참고
   ```

2. **빌드 시스템 에러**
   - 해결방법: Xcode에서 File > Project Settings로 이동하여 Build System을 "Legacy Build System"으로 변경하세요

3. **링커 에러**
   - 해결방법: 빌드 폴더를 정리하고 다시 빌드하세요:
   ```bash
   cd ios
   pod deintegrate
   pod install
   ```

### Android 문제

1. **뒤로가기 버튼 문제**
   - 해결방법: `shouldAutomaticallyHandleOnBackPressed`가 포함된 `MainActivity` 코드를 사용하세요

2. **Proguard 문제**
   - 해결방법: `proguard-rules.pro` 파일에 제공된 Proguard 규칙을 추가하세요

## 기여하기

이슈나 풀 리퀘스트를 통해 프로젝트에 기여해주세요.

## 라이선스

이 프로젝트는 BSD 2-Clause 라이선스 하에 있습니다. 자세한 내용은 LICENSE 파일을 참조하세요.