# CONTRIBUTING.md (오픈소스 기여 및 AI 협업 가이드라인)

이 프로젝트는 **사람 개발자(Human)**와 **AI 에이전트(Gemini, Claude, GPT 등)**가 상호 협력하여 만들어가는 오픈소스 프로젝트입니다. 모든 기여자는 본 가이드라인을 참조하여 환경을 설정하고, 코드를 작성하며, PR을 통한 검증 프로세스를 수행해 주시기 바랍니다.

---

## 🤝 1. 기여의 기본 원칙 (Welcome to Contribute)

우리의 주 목표는 **네이버 로그인 iOS SDK를 Swift Package Manager (SPM) 기반으로 안전하게 이주하고, CocoaPods 없이도 안정적인 빌드가 유지되도록 관리하는 것**입니다.
* 모든 기여(이슈 제보, PR 제출, 문서 수정)를 환영합니다.
* AI 에이전트를 개발 도구로 사용하는 기여자(Human-AI Pair) 역시 본 가이드의 표준 규격을 통해 AI 에이전트에 지시를 내림으로써 일관된 코드를 제출할 수 있습니다.

---

## 🤖 2. AI 에이전트 행동 규칙 (Rules for AI Contributors)

최근 많은 기여자들이 AI 에이전트(예: Claude Code, Gemini CLI 등)를 통해 기여합니다. AI 에이전트는 기여 프로세스에서 다음 규칙을 절대적으로 준수해야 합니다.

1. **최소 변경 원칙 (Minimal Diff)**
   - 비즈니스 로직 수정과 무관한 빈 줄 추가/삭제, 임의의 포맷팅 변경, 불필요한 주석 삭제는 불허합니다.
   - 기존의 변수명이나 메서드 시그니처를 수정할 경우, 반드시 그에 종속된 모든 파일의 참조를 동시에 수정하고 이를 설명해야 합니다.
2. **플랫폼 규격 및 Deprecated API 사용 제한**
   - Flutter SDK 및 플랫폼 네이티브 SDK에서 `Deprecated`로 지정된 API의 사용을 금지합니다.
   - 예: iOS SDK 연동 시 예전 방식인 `NaverThirdPartyLogin` 대신 최신 `NidThirdPartyLogin` 스펙을 유지해야 합니다.
3. **Xcode 빌드 캐시 붕괴 방지**
   - AI 에이전트의 내부 가상 환경(Git Worktree, Sandboxed directory 등)에서 직접 iOS 시뮬레이터 빌드(`flutter run`)를 수행하게 하지 마십시오.
   - Xcode 증분 빌드 캐시가 손상되어 빌드 속도가 170초 이상 지연되는 문제를 방지하기 위함입니다. 로컬 빌드 검증은 반드시 Human 개발자의 기본 작업 공간 또는 로컬 머신 빌드에서 명시적으로 지시하여 수행해야 합니다.

---

## ⚙️ 3. 자가 테스트 및 검증 프로세스 (Local Verification)

기여자는 PR을 제출하기 전에 반드시 로컬 환경에서 다음과 같은 자가 검증을 수행해야 합니다.

### 1) Dart 정적 분석 및 포맷팅 검증
로컬 터미널에서 다음 명령어를 실행하여 린트 에러나 경고가 없는지 확인합니다.
```bash
flutter format --set-exit-if-changed lib/ test/ example/
flutter analyze
```

### 2) 테스트 코드 실행 및 신규 테스트 작성
버그를 수정하거나 기능을 추가한 경우, 이에 대응하는 테스트 코드가 반드시 함께 작성되어야 합니다.
* **단위 테스트**: `test/` 디렉터리에 해당하는 테스트가 실패하지 않아야 합니다.
  ```bash
  flutter test
  ```
* **통합 테스트 (Integration Test)**: `example/` 디렉터리 내의 integration test를 수행하여 플랫폼 채널 동작이 원활한지 검증합니다.
  ```bash
  cd example
  flutter test integration_test/login_test.dart
  ```

### 3) iOS SPM 빌드 검증 (핵심)
이 레포지토리는 SPM 대응이 핵심 목적이므로, CocoaPods 환경을 걷어내고 독립적인 SPM 빌드가 성공하는지 검증해야 합니다.
```bash
cd example/ios
# CocoaPods 의존성 완전 제거 후 SPM 빌드 수행
pod deintegrate
rm -rf Podfile.lock Pods/
flutter build ios --no-codesign
```

---

## 🚀 4. CI/CD 검증 파이프라인 (GitHub Actions)

이 레포지토리는 Pull Request가 제출될 때마다 GitHub Actions 워크플로우를 가동하여 빌드 및 코드 품질을 자동 검사합니다.

* **동작하는 CI 워크플로우**:
  1. **Linter & Analyzer**: `flutter analyze`를 수행하여 코드 내 컴파일 경고나 린트 룰 위반이 없는지 검사합니다.
  2. **Dart Unit Tests**: `flutter test`를 수행하여 기 등록된 유닛 테스트들을 검증합니다.
  3. **Build Check (iOS & Android)**:
     - Android: `./gradlew assembleRelease` 빌드 검증
     - iOS: CocoaPods를 제외한 **Swift Package Manager 단독 활성화 모드** 환경에서 `xcodebuild`를 수행하여 빌드 정상 여부를 체크합니다.

> CI 파이프라인 검증이 실패한 PR은 머지 대상에서 즉시 제외되며, 기여자는 로그를 확인하여 수정본을 재제출해야 합니다.

---

## 🔍 5. 코드 리뷰 및 머지 승인 기준 (Review & Merge Process)

모든 PR은 메인 관리자(Human) 및 검증용 자동화 봇에 의해 리뷰를 거칩니다. 승인 기준은 다음과 같습니다.

1. **컴파일 및 린트 경고 Zero**: 
   - `flutter analyze` 결과 경고(Warning)나 린트 위반(Lints)이 단 하나도 없어야 합니다.
2. **테스트 커버리지 유지 및 신규 테스트 작성**:
   - 신규 기능 추가 또는 버그 수정 시, 변경된 논리를 검증할 수 있는 단위 테스트(`test/` 하위) 혹은 통합 테스트 코드가 반드시 PR에 **동시 포함**되어야 합니다. 테스트 코드 누락 시 리뷰 단계에서 추가 작성이 요구됩니다.
3. **SPM 및 CocoaPods 듀얼 빌드 정합성**:
   - iOS 빌드에서 SPM으로 빌드할 때와 기존 CocoaPods 환경으로 빌드할 때 모두 정상 컴파일되어야 합니다.
   - 조건부 컴파일 분기(`#if SWIFT_PACKAGE`)가 안전하게 구현되었는지 iOS 네이티브 소스코드를 면밀히 리뷰합니다.

기여 과정 중 빌드 이슈나 의문점이 생긴다면 언제든지 `Issues` 탭을 통해 의견을 올려주시기 바랍니다. 감사합니다!
