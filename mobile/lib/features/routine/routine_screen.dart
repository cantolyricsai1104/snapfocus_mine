import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../domain/routine.dart';
import '../../domain/routine_controller.dart';
import '../../domain/routine_ports.dart';
import '../../domain/goal.dart';
import '../gallery/gallery_screen.dart';
import '../goals/goals_screen.dart';
import 'camera_capture_screen.dart';

class RoutineScreen extends StatefulWidget {
  const RoutineScreen({
    super.key,
    required this.controller,
    this.snapshots,
    this.taskTitle,
    this.taskDurationMinutes,
    this.onStop,
    this.onEndWithoutPhoto,
  });

  final RoutineController controller;
  final SnapshotRepository? snapshots;
  final String? taskTitle;
  final int? taskDurationMinutes;
  final Future<void> Function()? onStop;
  final Future<Goal?> Function()? onEndWithoutPhoto;

  @override
  State<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends State<RoutineScreen>
    with WidgetsBindingObserver {
  Timer? _refreshTimer;
  RoutineState? _state;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _state = widget.controller.state;
    _restore();
    _refreshTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _refresh();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant RoutineScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller ||
        widget.controller.state != _state) {
      _state = widget.controller.state;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _restore();
  }

  Future<void> _restore() async {
    final state = await widget.controller.restore();
    if (mounted) setState(() => _state = state);
  }

  Future<void> _refresh() async {
    final current = widget.controller.state;
    if (current == null || current.status != RoutineStatus.running) return;
    final state = await widget.controller.refresh();
    if (mounted) setState(() => _state = state);
  }

  Future<void> _run(Future<RoutineState?> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final state = await action();
      if (mounted) setState(() => _state = state);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _start() => _run(
    () => widget.controller.start(
      focusDuration: Duration(minutes: widget.taskDurationMinutes ?? 25),
      breakDuration: const Duration(minutes: 5),
    ),
  );

  Future<void> _pause() => _run(() => widget.controller.pause());

  Future<void> _resume() => _run(() => widget.controller.resume());

  Future<void> _stop() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await widget.onStop?.call();
      final achievedGoal = await widget.onEndWithoutPhoto?.call();
      await widget.controller.stop();
      if (mounted) setState(() => _state = null);
      if (achievedGoal != null && mounted) {
        await showGoalAchieved(context, achievedGoal);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openCamera() async {
    final snapshots = widget.snapshots;
    final state = _state;
    if (snapshots == null || state == null) return;

    await Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (_) => CameraCaptureScreen(
          controller: widget.controller,
          snapshots: snapshots,
          routine: state,
          taskTitle: widget.taskTitle,
        ),
      ),
    );
    if (mounted) setState(() => _state = widget.controller.state);
  }

  @override
  Widget build(BuildContext context) {
    final state = _state;
    final colors = Theme.of(context).colorScheme;
    final isIdle = state == null;
    final isLocked = state?.status == RoutineStatus.locked;
    final isBreak = state?.phase == RoutinePhase.breakTime;
    final progress = state?.progress ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      appBar: AppBar(
        title: const Text('SnapFocus'),
        actions: [
          if (widget.snapshots != null)
            IconButton(
              tooltip: 'Photo gallery',
              onPressed: () => Navigator.of(context).push<void>(
                MaterialPageRoute(
                  builder: (_) => GalleryScreen(repository: widget.snapshots!),
                ),
              ),
              icon: const Icon(Icons.auto_awesome_mosaic_outlined),
            ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - 48,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLocked
                        ? 'One tiny reset before your next focus'
                        : isBreak
                        ? 'A soft pause for your brain'
                        : 'Make a little room for what matters',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFF756C68),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 18),
                  FitnessBall(
                    progress: progress,
                    state: isLocked
                        ? FitnessBallState.locked
                        : state == null
                        ? FitnessBallState.idle
                        : state.status == RoutineStatus.completed
                        ? FitnessBallState.completed
                        : FitnessBallState.growing,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    _headline(state),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFF29313D),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isIdle
                        ? 'Your focus buddy is ready'
                        : isLocked
                        ? 'A quick photo unlocks the next round, or end the routine here.'
                        : isBreak
                        ? 'Look away, breathe, and let the ball rest.'
                        : 'Growing with your focus',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF8D827B),
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _TimerCard(
                    state: state,
                    idleFocusDuration: Duration(
                      minutes: widget.taskDurationMinutes ?? 25,
                    ),
                  ),
                  const SizedBox(height: 22),
                  if (isIdle)
                    _PrimaryButton(
                      label: 'Start focus',
                      icon: Icons.play_arrow_rounded,
                      onPressed: _busy ? null : _start,
                    )
                  else if (isLocked)
                    _PrimaryButton(
                      label: 'Take a photo to continue',
                      icon: Icons.camera_alt_rounded,
                      onPressed: _busy ? null : _openCamera,
                    )
                  else if (state.status == RoutineStatus.paused)
                    _PrimaryButton(
                      label: 'Resume',
                      icon: Icons.play_arrow_rounded,
                      onPressed: _busy ? null : _resume,
                    )
                  else
                    _PrimaryButton(
                      label: isBreak ? 'Keep resting' : 'Pause',
                      icon: isBreak
                          ? Icons.self_improvement_rounded
                          : Icons.pause_rounded,
                      onPressed: isBreak || _busy ? null : _pause,
                    ),
                  if (!isIdle) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _busy ? null : _stop,
                      child: Text(
                        isLocked ? 'End without photo' : 'End routine',
                        style: TextStyle(color: colors.primary),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _headline(RoutineState? state) {
    if (state == null) return widget.taskTitle ?? 'Ready when you are';
    if (state.status == RoutineStatus.locked) return 'Snapshot moment';
    if (state.phase == RoutinePhase.breakTime) return 'Break time';
    if (state.status == RoutineStatus.paused) return 'Focus paused';
    return widget.taskTitle ?? 'You are in the zone';
  }
}

class _TimerCard extends StatelessWidget {
  const _TimerCard({required this.state, required this.idleFocusDuration});

  final RoutineState? state;
  final Duration idleFocusDuration;

  @override
  Widget build(BuildContext context) {
    final duration = state == null
        ? idleFocusDuration
        : state!.status == RoutineStatus.paused
        ? state!.pausedRemaining ?? Duration.zero
        : state!.progress == 0
        ? (state!.phase == RoutinePhase.focus
              ? state!.focusDuration
              : state!.breakDuration)
        : state!.endsAt == null
        ? Duration.zero
        : state!.endsAt!.difference(DateTime.now());
    final remaining = duration.isNegative ? Duration.zero : duration;
    final minutes = remaining.inMinutes.toString().padLeft(2, '0');
    final seconds = (remaining.inSeconds % 60).toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.78),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF1E3D7)),
      ),
      child: Text(
        '$minutes:$seconds',
        style: const TextStyle(
          color: Color(0xFF29313D),
          fontSize: 32,
          fontWeight: FontWeight.w800,
          fontFeatures: [FontFeature.tabularFigures()],
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFFE97965),
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFE9C4B9),
        minimumSize: const Size.fromHeight(56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
      ),
    );
  }
}

enum FitnessBallState { idle, growing, completed, locked }

class FitnessBall extends StatelessWidget {
  const FitnessBall({super.key, required this.progress, required this.state});

  final double progress;
  final FitnessBallState state;

  @override
  Widget build(BuildContext context) {
    final growth = state == FitnessBallState.idle
        ? 0.86
        : 0.86 + progress * 0.14;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.86, end: growth),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: SizedBox(
        width: 230,
        height: 230,
        child: CustomPaint(painter: _FitnessBallPainter(state: state)),
      ),
    );
  }
}

class _FitnessBallPainter extends CustomPainter {
  const _FitnessBallPainter({required this.state});

  final FitnessBallState state;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2 + 4);
    final radius = size.width * 0.36;
    final shadow = Paint()..color = const Color(0x1A9B6E58);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy + radius + 19),
        width: radius * 1.45,
        height: 18,
      ),
      shadow,
    );

    final body = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFFB49D), Color(0xFFE97869)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, body);

    final outline = Paint()
      ..color = const Color(0xFFB95650)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawCircle(center, radius, outline);

    final faceY = center.dy - 4;
    final eye = Paint()..color = const Color(0xFF29313D);
    canvas.drawCircle(Offset(center.dx - 25, faceY), 4.5, eye);
    canvas.drawCircle(Offset(center.dx + 25, faceY), 4.5, eye);

    final blush = Paint()..color = const Color(0x55D95868);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx - 39, faceY + 18),
        width: 25,
        height: 12,
      ),
      blush,
    );
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(center.dx + 39, faceY + 18),
        width: 25,
        height: 12,
      ),
      blush,
    );

    final smile = Paint()
      ..color = const Color(0xFF8D3F49)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    final smilePath = Path()
      ..moveTo(center.dx - 11, faceY + 12)
      ..quadraticBezierTo(center.dx, faceY + 23, center.dx + 11, faceY + 12);
    canvas.drawPath(smilePath, smile);

    final limb = Paint()
      ..color = const Color(0xFF8D3F49)
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(
      Offset(center.dx - radius + 2, center.dy + 20),
      Offset(center.dx - radius - 18, center.dy + 4),
      limb,
    );
    canvas.drawLine(
      Offset(center.dx + radius - 2, center.dy + 20),
      Offset(center.dx + radius + 18, center.dy + 4),
      limb,
    );
    canvas.drawLine(
      Offset(center.dx - 23, center.dy + radius - 2),
      Offset(center.dx - 30, center.dy + radius + 20),
      limb,
    );
    canvas.drawLine(
      Offset(center.dx + 23, center.dy + radius - 2),
      Offset(center.dx + 30, center.dy + radius + 20),
      limb,
    );

    if (state == FitnessBallState.locked) {
      final lock = Paint()..color = const Color(0xFFE7B84F);
      canvas.drawCircle(Offset(center.dx, center.dy - radius - 8), 17, lock);
      final key = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3;
      canvas.drawArc(
        Rect.fromCenter(
          center: Offset(center.dx, center.dy - radius - 10),
          width: 12,
          height: 14,
        ),
        math.pi,
        math.pi,
        false,
        key,
      );
      canvas.drawLine(
        Offset(center.dx, center.dy - radius - 4),
        Offset(center.dx, center.dy - radius + 2),
        key,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _FitnessBallPainter oldDelegate) =>
      oldDelegate.state != state;
}
