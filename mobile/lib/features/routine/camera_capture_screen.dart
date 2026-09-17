import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/routine.dart';
import '../../domain/routine_controller.dart';
import '../../domain/routine_ports.dart';
import '../../domain/snapshot.dart';

class CameraCaptureScreen extends StatefulWidget {
  const CameraCaptureScreen({
    super.key,
    required this.controller,
    required this.snapshots,
    required this.routine,
    this.taskTitle,
  });

  final RoutineController controller;
  final SnapshotRepository snapshots;
  final RoutineState routine;
  final String? taskTitle;

  @override
  State<CameraCaptureScreen> createState() => _CameraCaptureScreenState();
}

class _CameraCaptureScreenState extends State<CameraCaptureScreen> {
  CameraController? _camera;
  String? _error;
  bool _capturing = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw StateError('No camera is available.');
      final camera = CameraController(
        cameras.first,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await camera.initialize();
      if (!mounted) {
        await camera.dispose();
        return;
      }
      setState(() => _camera = camera);
    } catch (error) {
      if (mounted) setState(() => _error = '$error');
    }
  }

  @override
  void dispose() {
    _camera?.dispose();
    super.dispose();
  }

  Future<void> _capture() async {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized || _capturing) return;
    setState(() => _capturing = true);
    try {
      final image = await camera.takePicture();
      final now = DateTime.now();
      final appDirectory = await getApplicationDocumentsDirectory();
      final photoDirectory = Directory('${appDirectory.path}/snapshots');
      await photoDirectory.create(recursive: true);
      final savedImage = await File(
        image.path,
      ).copy('${photoDirectory.path}/photo-${now.microsecondsSinceEpoch}.jpg');
      await widget.controller.unlockWithPhoto(
        CapturedPhoto(
          id: 'photo-${now.microsecondsSinceEpoch}',
          path: savedImage.path,
          capturedAt: now,
          routineId: widget.routine.id,
          taskTitle: widget.taskTitle,
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (error) {
      if (mounted) {
        setState(() => _capturing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save this snapshot: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final camera = _camera;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('A tiny reset'),
      ),
      body: _error != null
          ? _CameraMessage(error: _error!)
          : camera == null || !camera.value.isInitialized
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(camera),
                const _CameraHint(),
                Positioned(
                  bottom: 32,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Semantics(
                      button: true,
                      label: 'Capture snapshot',
                      child: GestureDetector(
                        onTap: _capturing ? null : _capture,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            color: _capturing ? Colors.grey : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFFE97965),
                              width: 6,
                            ),
                          ),
                          child: _capturing
                              ? const Padding(
                                  padding: EdgeInsets.all(22),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt_rounded,
                                  color: Color(0xFFE97965),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _CameraHint extends StatelessWidget {
  const _CameraHint();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      left: 24,
      right: 24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            'Capture the space you are leaving better than you found it.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _CameraMessage extends StatelessWidget {
  const _CameraMessage({required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Text(
          'Camera unavailable. You can end this routine and try again later.\n\n$error',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
