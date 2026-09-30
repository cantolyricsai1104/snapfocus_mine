import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../domain/routine.dart';
import '../domain/routine_ports.dart';
import '../domain/task.dart';

class NotificationRequest {
  const NotificationRequest({
    required this.id,
    required this.title,
    required this.body,
    required this.scheduledAt,
  });

  final int id;
  final String title;
  final String body;
  final DateTime scheduledAt;
}

abstract interface class NotificationPlatform {
  Future<void> schedule(NotificationRequest request);

  Future<void> cancel(int id);
}

class LocalNotificationScheduler implements NotificationScheduler {
  LocalNotificationScheduler(this.platform);

  final NotificationPlatform platform;

  @override
  Future<void> schedulePhaseEnd(RoutineState state) async {
    final endsAt = state.endsAt;
    if (endsAt == null) return;

    final isFocus = state.phase == RoutinePhase.focus;
    await platform.schedule(
      NotificationRequest(
        id: _notificationId(state),
        title: isFocus ? 'Focus complete' : 'Break complete',
        body: isFocus
            ? 'Take a break and reset your space.'
            : 'Capture your workspace to unlock Focus.',
        scheduledAt: endsAt,
      ),
    );
  }

  @override
  Future<void> cancelPhaseEnd(RoutineState state) async {
    await platform.cancel(_notificationId(state));
  }
}

int _notificationId(RoutineState state) {
  var value = 17;
  for (final codeUnit in state.id.codeUnits) {
    value = (value * 31 + codeUnit) & 0x7fffffff;
  }
  return value ^ state.phase.index;
}

class FlutterNotificationPlatform implements NotificationPlatform {
  FlutterNotificationPlatform({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  Future<void> initialize({void Function(String? payload)? onTap}) async {
    if (kIsWeb) {
      _initialized = true;
      return;
    }

    tz_data.initializeTimeZones();
    final localTimezone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTimezone.identifier));

    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        onTap?.call(response.payload);
      },
    );
    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (kIsWeb) return true;

    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final iosGranted =
        await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        true;
    final androidGranted =
        await android?.requestNotificationsPermission() ?? true;
    return iosGranted && androidGranted;
  }

  Future<void> scheduleTaskReminders(List<TaskBlock> tasks) async {
    if (kIsWeb) return;
    _assertInitialized();
    final today = DateTime.now();
    for (var offset = 0; offset < 14; offset++) {
      final date = DateTime(today.year, today.month, today.day + offset);
      final dateKey = _dateKey(date);
      for (final task in tasks) {
        if (task.scheduledTime == null || !task.isScheduledOn(dateKey)) {
          continue;
        }
        final notificationId = _taskNotificationId(task.id, dateKey);
        if (task.reminderMinutesBefore <= 0) {
          await cancel(notificationId);
          continue;
        }
        final parts = task.scheduledTime!.split(':').map(int.parse).toList();
        final startsAt = DateTime(
          date.year,
          date.month,
          date.day,
          parts[0],
          parts[1],
        );
        final reminderAt = startsAt.subtract(
          Duration(minutes: task.reminderMinutesBefore),
        );
        if (!reminderAt.isAfter(today)) continue;
        await schedule(
          NotificationRequest(
            id: notificationId,
            title: 'Upcoming task',
            body:
                '${task.title} starts in ${task.reminderMinutesBefore} minutes.',
            scheduledAt: reminderAt,
          ),
        );
      }
    }
  }

  @override
  Future<void> schedule(NotificationRequest request) async {
    if (kIsWeb) return;

    _assertInitialized();
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        'snapfocus_routine',
        'SnapFocus routine',
        channelDescription: 'Focus and break completion reminders.',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await _plugin.zonedSchedule(
      id: request.id,
      title: request.title,
      body: request.body,
      scheduledDate: tz.TZDateTime.from(request.scheduledAt, tz.local),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: 'routine:${request.id}',
    );
  }

  @override
  Future<void> cancel(int id) async {
    if (kIsWeb) return;

    _assertInitialized();
    await _plugin.cancel(id: id);
  }

  void _assertInitialized() {
    if (!_initialized) {
      throw StateError('Flutter notification platform is not initialized.');
    }
  }
}

int _taskNotificationId(String taskId, String date) {
  var value = 97;
  for (final codeUnit in '$taskId:$date'.codeUnits) {
    value = (value * 31 + codeUnit) & 0x7fffffff;
  }
  return value;
}

String _dateKey(DateTime value) =>
    '${value.year}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
