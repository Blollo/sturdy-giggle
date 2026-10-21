import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers.dart';
import 'theme.dart';

class CatPhoto extends ConsumerWidget {
  const CatPhoto({
    required this.path,
    this.absolute = false,
    this.cacheWidth = 800,
    super.key,
  });
  final String path;
  final bool absolute;
  final int cacheWidth;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Image.file(
    File(
      absolute ? path : ref.watch(repositoryProvider).photos.absolutePath(path),
    ),
    fit: BoxFit.cover,
    width: double.infinity,
    height: double.infinity,
    cacheWidth: cacheWidth,
    errorBuilder: (_, _, _) => const ColoredBox(
      color: Color(0xFFE8EBE0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CatSilhouette(size: 72),
            SizedBox(height: 8),
            Text('Photo unavailable'),
          ],
        ),
      ),
    ),
  );
}

class CatSilhouette extends StatelessWidget {
  const CatSilhouette({this.size = 120, super.key});
  final double size;
  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _CatPainter()),
  );
}

class _CatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100, size.height / 100);
    final paint = Paint()..color = forest.withValues(alpha: 0.8);
    final body = Path()
      ..moveTo(28, 44)
      ..lineTo(23, 15)
      ..quadraticBezierTo(36, 19, 43, 29)
      ..quadraticBezierTo(52, 26, 60, 29)
      ..lineTo(77, 15)
      ..lineTo(75, 45)
      ..quadraticBezierTo(80, 57, 67, 65)
      ..quadraticBezierTo(77, 76, 73, 91)
      ..lineTo(31, 91)
      ..quadraticBezierTo(26, 73, 37, 65)
      ..quadraticBezierTo(23, 59, 28, 44)
      ..close();
    canvas.drawPath(body, paint);
    canvas.drawPath(
      Path()
        ..moveTo(70, 87)
        ..cubicTo(99, 89, 98, 61, 87, 66),
      Paint()
        ..color = paint.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..strokeCap = StrokeCap.round,
    );
    final eyes = Paint()..color = paper;
    canvas.drawOval(const Rect.fromLTWH(36, 43, 7, 4), eyes);
    canvas.drawOval(const Rect.fromLTWH(60, 43, 7, 4), eyes);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class SectionLabel extends StatelessWidget {
  const SectionLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Text(text.toUpperCase(), style: Theme.of(context).textTheme.labelSmall);
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.title,
    required this.message,
    this.action,
    super.key,
  });
  final String title, message;
  final Widget? action;
  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Color(0xFFE8EBE0),
              shape: BoxShape.circle,
            ),
            child: const CatSilhouette(),
          ),
          const SizedBox(height: 28),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: muted, height: 1.6),
          ),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    ),
  );
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
}

String displayDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  final local = date.toLocal();
  return '${local.day} ${months[local.month - 1]} ${local.year}';
}
