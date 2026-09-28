import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  bool _allTime = false;
  bool _showExample = false;

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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear all proof photos?'),
        content: const Text(
          'This removes the private copies from this device.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
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
    final today = DateTime.now();
    final todayPhotos = _photos
        .where((photo) => _sameDay(photo.capturedAt, today))
        .toList(growable: false);
    final visiblePhotos = _allTime ? _photos : todayPhotos;
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
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                const Text(
                  'Daily visual proof of every session unlocked.',
                  style: TextStyle(
                    color: Color(0xFF756C68),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _GalleryStat(
                        label: 'Unlocked today',
                        value: '${todayPhotos.length}',
                        icon: Icons.verified_rounded,
                        color: const Color(0xFF5E9B78),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _GalleryStat(
                        label: 'Focus proof',
                        value: '${todayPhotos.length * 25}m',
                        icon: Icons.timer_rounded,
                        color: const Color(0xFFE97965),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Today')),
                    ButtonSegment(value: true, label: Text('All time')),
                  ],
                  selected: {_allTime},
                  onSelectionChanged: (value) =>
                      setState(() => _allTime = value.first),
                ),
                const SizedBox(height: 14),
                if (visiblePhotos.isEmpty && !_showExample)
                  _EmptyGallery(
                    onShowExample: kIsWeb
                        ? () => setState(() => _showExample = true)
                        : null,
                  )
                else if (visiblePhotos.isEmpty && _showExample)
                  const _DemoPhotoGrid()
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.82,
                        ),
                    itemCount: visiblePhotos.length,
                    itemBuilder: (context, index) => _PhotoTile(
                      photo: visiblePhotos[index],
                      onDelete: () => _delete(visiblePhotos[index]),
                      onOpen: () => _showPhoto(visiblePhotos[index]),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _showPhoto(CapturedPhoto photo) async {
    await showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.file(
                File(photo.path),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 220,
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              photo.taskTitle ?? 'SnapFocus proof',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              '${photo.capturedAt.month}/${photo.capturedAt.day} · ${photo.capturedAt.hour.toString().padLeft(2, '0')}:${photo.capturedAt.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(color: Colors.white70),
            ),
            TextButton.icon(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(
                    text:
                        'SnapFocus proof: ${photo.taskTitle ?? 'Focus session'}',
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Proof details copied')),
                );
              },
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              label: const Text(
                'Copy proof details',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GalleryStat extends StatelessWidget {
  const _GalleryStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(color: const Color(0xFFF1E3D7)),
    ),
    child: Row(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Color(0xFF8D827B), fontSize: 12),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _EmptyGallery extends StatelessWidget {
  const _EmptyGallery({this.onShowExample});

  final VoidCallback? onShowExample;

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
            if (onShowExample != null) ...[
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: onShowExample,
                icon: const Icon(Icons.visibility_outlined, size: 18),
                label: const Text('See example'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DemoPhotoGrid extends StatelessWidget {
  const _DemoPhotoGrid();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Example gallery',
            style: TextStyle(
              color: Color(0xFF29313D),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.82,
            children: const [_DemoPhotoTile()],
          ),
          const SizedBox(height: 8),
          const Text(
            'This example is only for the web preview. Real photos will appear here after a session.',
            style: TextStyle(color: Color(0xFF8D827B), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _DemoPhotoTile extends StatelessWidget {
  const _DemoPhotoTile();

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.82,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFC8B7), Color(0xFFE6D8F5)],
                ),
              ),
              child: CustomPaint(painter: _DemoPhotoPainter()),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Deep focus',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      shadows: [Shadow(color: Colors.black38, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Today · 25m',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          shadows: [
                            Shadow(color: Colors.black38, blurRadius: 4),
                          ],
                        ),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.28),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          child: Text(
                            'Example',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoPhotoPainter extends CustomPainter {
  const _DemoPhotoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withValues(alpha: 0.52);
    final shadow = Paint()..color = const Color(0x265C4A60);
    final deskTop = size.height * 0.72;

    canvas.drawCircle(Offset(size.width * 0.72, size.height * 0.28), 34, paint);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.width * 0.22, deskTop + 12),
        width: 94,
        height: 18,
      ),
      shadow,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.1, deskTop, size.width * 0.8, 7),
      paint,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.2, deskTop + 7, 7, size.height * 0.2),
      shadow,
    );
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.73, deskTop + 7, 7, size.height * 0.2),
      shadow,
    );
    canvas.drawCircle(Offset(size.width * 0.27, deskTop - 20), 22, paint);
    canvas.drawRect(
      Rect.fromLTWH(size.width * 0.18, deskTop - 20, 18, 20),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PhotoTile extends StatelessWidget {
  const _PhotoTile({
    required this.photo,
    required this.onDelete,
    required this.onOpen,
  });

  final CapturedPhoto photo;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onOpen,
      child: ClipRRect(
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
      ),
    );
  }

  String _dateLabel(DateTime date) => '${date.month}/${date.day}';
}

bool _sameDay(DateTime first, DateTime second) =>
    first.year == second.year &&
    first.month == second.month &&
    first.day == second.day;
