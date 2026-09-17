# SnapFocus mobile MVP

SnapFocus 是一個 local-first 的 Flutter 手機 MVP：Focus / Break 計時會以絕對時間保存，因此 App 進入背景、鎖定螢幕、被滑掉或手機重開後，回到 App 仍會從正確的時間點繼續。

## 技術堆疊

- Flutter + Dart
- Riverpod：App 組裝與依賴注入
- Drift + SQLite：本機 routine 與私有相片資料
- `flutter_local_notifications` + timezone：一般本機通知，不使用全螢幕鬧鐘
- `camera`：Break 結束後的相片解鎖
- Rive-ready UI seam：目前使用 Flutter vector fallback，日後可替換為 `.riv` 動畫資產

## 已移植的網站功能

- Tasks：日期切換、Focus / Break 統計、完成狀態、排序、刪除、啟動計時器
- Task editor：Focus / Break 類型、預設或自訂分鐘數、時間、每日／每週／每月重複
- Calendar：Day / Month / Year 檢視、日期導覽、Today、新增、編輯、調整時間、刪除
- Timer：絕對時間計時、背景／鎖屏後恢復、暫停、繼續、重設、跳過、加減時間
- Proof：Break 結束後拍照解鎖、Today / All time 相片檢視、查看詳情、刪除、清除

所有資料目前只儲存在裝置本機；通知只負責提醒，點擊後回到 App 繼續操作。

## 開發

```sh
flutter pub get
flutter test
flutter analyze
flutter run
```

例行計時器預設為 25 分鐘 Focus、5 分鐘 Break；從 Tasks 啟動時會使用該 task 的分鐘數。Break 結束後需拍攝一張相片，才會開始下一輪 Focus；相片只儲存在裝置本機。

Android 實機或模擬器執行範例：

```sh
flutter devices
flutter run -d <device-id>
```

目前 Proof 的 Focus 分鐘統計仍以每張相片 25 分鐘估算，之後可再將實際 routine duration 寫入相片資料。
