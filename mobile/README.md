# SnapFocus Flutter App

SnapFocus 是一個 local-first 的 Flutter 手機 App。它提供 Focus / Break 計時、Tasks、Calendar，以及 Break 結束後的相片 Proof 流程。計時使用絕對時間保存，因此 App 進入背景、鎖定螢幕、被滑掉或手機重開後，回到 App 仍會從正確的時間點繼續。

目前資料只儲存在裝置本機。通知只負責提醒；使用者點擊通知後，會回到 App 繼續操作，不使用全螢幕鬧鐘。

## 技術堆疊

- Flutter + Dart
- Riverpod：App 組裝與依賴注入
- Drift + SQLite：本機 Tasks、routine 與 Proof 相片資料
- `flutter_local_notifications` + timezone：本機通知
- `camera`：Break 結束後的相片解鎖
- Rive-ready UI seam：目前使用 Flutter vector fallback，日後可替換為 `.riv` 動畫資產

## 需要先安裝的工具

### 必要工具

- Flutter stable channel
- Dart SDK（由 Flutter 一起提供）
- Android Studio（Android 開發及模擬器）
- Git

### 目前建議版本

本專案目前以以下版本開發及驗證：

```text
Flutter 3.38.5
Dart 3.10.4
```

`pubspec.yaml` 要求 Dart `^3.10.4`。如果 Flutter 版本太舊，請先更新 Flutter，或使用與專案相容的 stable 版本。

### macOS 額外工具

如果要執行 iOS 版本，還需要：

- Xcode
- Xcode Command Line Tools
- CocoaPods

Android 版本則需要 Android Studio 的 Android SDK、SDK Platform、SDK Build-Tools 及至少一個 Android Emulator system image。

## 第一次設定

### 1. 進入 Flutter 專案目錄

請注意：`pubspec.yaml` 位於 `mobile` 目錄，不是在 repository 根目錄。所有 Flutter 指令都要從這裡執行。

```sh
cd /Users/wingswin/Documents/Snapfocus/SnapFocus/.worktrees/snapfocus-mobile-mvp/mobile
```

如果你的專案位置不同，請把路徑換成自己電腦上的 `mobile` 目錄。

### 2. 檢查 Flutter 環境

```sh
flutter --version
flutter doctor
```

如果 `flutter doctor` 顯示 Android toolchain 或 Xcode 有錯誤，先按照它列出的項目補齊工具，再繼續下一步。

### 3. 安裝 Flutter dependencies

```sh
flutter pub get
```

看到 `newer versions available` 不代表安裝失敗。只要最後顯示 `Got dependencies!`，就代表目前版本的依賴已成功安裝。

### Supabase 登入設定

本機的 `supabase.local.json` 已設定專案 URL 與 publishable key，並由 `.gitignore` 排除，不會提交到 Git。啟動 App 時將設定檔傳入 Flutter：

```sh
flutter pub get
flutter run --dart-define-from-file=supabase.local.json
```

登入頁支援 email/password 註冊、登入和密碼重設。Supabase 若要求 email confirmation，新使用者需要先點擊確認信中的連結，再回到 App 登入。發佈建置也必須用相同的 `--dart-define-from-file` 參數傳入設定。不要把 service-role key 放進 App。

## 啟動 Android 版本

### 方法 A：使用 Android Studio

1. 開啟 Android Studio。
2. 開啟 Android SDK Manager，確認已安裝 Android SDK、SDK Platform 及 SDK Build-Tools。
3. 開啟 Device Manager，啟動一個 Android Emulator。
4. 在 `mobile` 目錄執行：

```sh
flutter devices
flutter run
```

### 方法 B：指定裝置

先查看裝置 ID：

```sh
flutter devices
```

再指定裝置啟動。例如目前使用的模擬器是 `emulator-5554`：

```sh
flutter run -d emulator-5554
```

如果使用實體 Android 手機，請在手機開啟 Developer options 及 USB debugging，然後接受手機上的電腦授權提示。

## 啟動 iOS 版本

只有在 macOS 安裝 Xcode 後，才可以執行 iOS 版本。

```sh
cd /Users/wingswin/Documents/Snapfocus/SnapFocus/.worktrees/snapfocus-mobile-mvp/mobile
flutter pub get
open -a Simulator
flutter devices
flutter run -d <ios-device-id>
```

第一次使用相機時，請允許 App 使用 Camera。iOS 的相機權限說明已設定在 `ios/Runner/Info.plist`。

## 常用開發指令

請確認目前位於 `mobile` 目錄：

```sh
# 安裝或更新 dependencies
flutter pub get

# 執行所有測試
flutter test

# 執行靜態分析
flutter analyze

# 產生 Android debug APK
flutter build apk --debug --target-platform android-arm64

# 啟動 App
flutter run -d <device-id>
```

成功產生的 APK 位於：

```text
build/app/outputs/flutter-apk/app-debug.apk
```

## 已實作功能

- Tasks：日期切換、Focus / Break 統計、完成狀態、排序、刪除、啟動計時器
- Task editor：Focus / Break 類型、預設或自訂分鐘數、時間、每日／每週／每月重複
- Calendar：Day / Month / Year 檢視、日期導覽、Today、新增、編輯、調整時間、刪除
- Timer：絕對時間計時、背景／鎖屏後恢復、暫停、繼續、重設、跳過、加減時間
- Proof：Break 結束後拍照解鎖、Today / All time 相片檢視、查看詳情、刪除、清除

例行計時器預設為 25 分鐘 Focus、5 分鐘 Break；從 Tasks 啟動時會使用該 task 的分鐘數。

## 權限與行為

Android 會使用以下權限：

- Camera：拍攝 Proof 相片
- Notifications：顯示計時提醒
- Receive boot completed：手機重新啟動後恢復通知排程

相片及 Tasks 只儲存在裝置本機，不會上傳伺服器。

目前 Proof 的 Focus 分鐘統計仍以每張相片 25 分鐘估算，之後可再將實際 routine duration 寫入相片資料。

## 常見問題

### `No pubspec.yaml file found`

代表你不在 Flutter 專案根目錄。請進入包含 `pubspec.yaml` 的 `mobile` 目錄：

```sh
cd /Users/wingswin/Documents/Snapfocus/SnapFocus/.worktrees/snapfocus-mobile-mvp/mobile
flutter pub get
```

### `No supported devices connected`

查看 Flutter 找到的裝置：

```sh
flutter devices
```

如果沒有 Android 裝置，請在 Android Studio 的 Device Manager 啟動 Emulator，或連接已開啟 USB debugging 的實體手機。

### `NDK ... did not have a source.properties file`

這通常代表 NDK 下載不完整。先刪除錯誤訊息中指定的那一個 NDK 版本資料夾，再由 Android Studio 重新安裝相同版本。

例如錯誤訊息若指向：

```text
/Users/<your-name>/Library/Android/sdk/ndk/28.2.13676358
```

請在 Android Studio 的 SDK Manager 重新安裝該 NDK，不要刪除整個 Android SDK 目錄。

### `requires core library desugaring to be enabled`

本專案已在 `android/app/build.gradle.kts` 啟用 core library desugaring。如果你從其他分支重新產生 Android 目錄，請確認這兩項仍存在：

```kotlin
compileOptions {
    isCoreLibraryDesugaringEnabled = true
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
```

### `No space left on device`

Flutter、Gradle、Android SDK 和 Emulator 都會使用大量磁碟空間。可以先清理這個專案可重新產生的 build 檔案：

```sh
flutter clean
flutter pub get
```

如果仍然不足，請在 Android Studio 的 SDK Manager 移除不使用的 SDK versions、NDK versions 及 Emulator system images。不要移除目前正在使用的版本。

### 第一次 build 很慢

第一次 build 需要下載 Gradle、Android 原生套件及部分 Flutter plugin 資產。只要最後看到 `Built ... app-debug.apk`，就代表 build 成功。

## 專案結構

```text
mobile/
├── lib/
│   ├── data/        # Drift database 與 repository
│   ├── domain/      # Routine、Task、Snapshot domain logic
│   ├── features/    # Tasks、Calendar、Timer、Gallery UI
│   ├── services/    # Local notifications 等服務
│   ├── app.dart     # App shell 與底部導覽
│   └── main.dart    # App 啟動及依賴組裝
├── test/            # Domain、repository、widget、notification tests
├── android/         # Android 專案設定
├── ios/             # iOS 專案設定
├── pubspec.yaml     # Flutter dependencies
└── README.md        # 本設定文件
```
