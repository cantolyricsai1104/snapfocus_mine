import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/routine_ports.dart';
import '../../domain/snapshot.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key, required this.repository});

  final SnapshotRepository repository;

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<CapturedPhoto> _photos = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final photos = await widget.repository.list();
    if (mounted) {
      setState(() {
        _photos = photos;
        _loading = false;
      });
    }
  }

  Future<void> _delete(CapturedPhoto photo) async {
    await _deleteFile(photo.path);
    await widget.repository.delete(photo.id);
    await _load();
  }

  Future<void> _clearAll() async {
    for (final photo in _photos) {
      await _deleteFile(photo.path);
    }
    await widget.repository.clearAll();
    await _load();
  }

  Future<void> _deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F2),
      appBar: AppBar(
        title: const Text('Little wins'),
        actions: [
          if (_photos.isNotEmpty)
            IconButton(
              tooltip: 'Delete all photos',
              onPressed: _clearAll,
              icon: const Icon(Icons.delete_sweep_outlined),
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _photos.isEmpty
          ? const _EmptyGallery()
          : GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 0.82,
              ),
              itemCount: _photos.length,
              itemBuilder: (context, index) => _PhotoTile(
                photo: _photos[index],
                onDelete: () => _delete(_photos[index]),
              ),
            ),
    );
  }
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.photo_camera_back_outlined,
              size: 48,
              color: Color(0xFFE19B88),
            ),
            const SizedBox(height: 16),
            Text(
              'Your quiet wins will live here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(0xFF29313D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({required this.photo, required this.onDelete});

  final CapturedPhoto photo;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(photo.path),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: const Color(0xFFF3E1D5),
              alignment: Alignment.center,
              child: const Icon(
                Icons.image_not_supported_outlined,
                color: Color(0xFFB88F80),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: CircleAvatar(
              backgroundColor: Colors.black.withValues(alpha: 0.45),
              child: IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 19,
                ),
              ),
            ),
          ),
          Positioned(
            left: 10,
            right: 10,
            bottom: 10,
            child: Text(
              _dateLabel(photo.capturedAt),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _dateLabel(DateTime date) => '${date.month}/${date.day}';
}
