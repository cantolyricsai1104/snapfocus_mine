# SnapFocus mobile MVP

SnapFocus 是一個 local-first 的 Flutter 手機 MVP：Focus / Break 計時會以絕對時間保存，因此 App 進入背景、鎖定螢幕、被滑掉或手機重開後，回到 App 仍會從正確的時間點繼續。

## 技術堆疊

- Flutter + Dart
- Riverpod：App 組裝與依賴注入
- Drift + SQLite：本機 routine 與私有相片資料
- `flutter_local_notifications` + timezone：一般本機通知，不使用全螢幕鬧鐘
- `camera`：Break 結束後的相片解鎖
- Rive-ready UI seam：目前使用 Flutter vector fallback，日後可替換為 `.riv` 動畫資產

## 開發

```sh
flutter pub get
flutter test
flutter analyze
flutter run
```

目前第一版固定為 25 分鐘 Focus、5 分鐘 Break。Break 結束後需拍攝一張相片，才會開始下一輪 Focus；相片只儲存在裝置本機。
