import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;

class StoredPhoto {
  const StoredPhoto(this.path, this.width, this.height);
  final String path;
  final int width, height;
}

abstract interface class PhotoStore {
  Future<StoredPhoto> importPhoto(String sourcePath, String id);
  Future<void> remove(String relativePath);
  Future<void> cleanOrphans(Set<String> referencedPaths);
  String absolutePath(String relativePath);
}

class DiskPhotoStore implements PhotoStore {
  DiskPhotoStore(this.root);
  final Directory root;

  @override
  String absolutePath(String relativePath) => p.join(root.path, relativePath);

  @override
  Future<StoredPhoto> importPhoto(String sourcePath, String id) async {
    final folder = Directory(p.join(root.path, 'photos'));
    await folder.create(recursive: true);
    final relative = p.join('photos', '$id.jpg');
    final target = absolutePath(relative);
    final staging = '$target.part';
    try {
      final input = await File(sourcePath).readAsBytes();
      final buffer = await ui.ImmutableBuffer.fromUint8List(input);
      final descriptor = await ui.ImageDescriptor.encoded(buffer);
      final scale = math.min(
        1.0,
        1600 / math.max(descriptor.width, descriptor.height),
      );
      final width = math.max(1, (descriptor.width * scale).floor());
      final height = math.max(1, (descriptor.height * scale).floor());
      descriptor.dispose();
      buffer.dispose();
      var output = await FlutterImageCompress.compressWithFile(
        sourcePath,
        minWidth: width,
        minHeight: height,
        quality: 85,
        format: CompressFormat.jpeg,
        keepExif: false,
        autoCorrectionAngle: true,
      );
      if (output == null) {
        throw const FileSystemException('Could not process photo');
      }
      var dimensions = await _dimensions(output);
      // Native decoders can disagree about EXIF-oriented dimensions. Enforce
      // the limit against the normalized JPEG, whose orientation is now fixed.
      if (math.max(dimensions.$1, dimensions.$2) > 1600) {
        final ratio = 1600 / math.max(dimensions.$1, dimensions.$2);
        output = await FlutterImageCompress.compressWithList(
          output,
          minWidth: math.max(1, (dimensions.$1 * ratio).floor()),
          minHeight: math.max(1, (dimensions.$2 * ratio).floor()),
          quality: 85,
          format: CompressFormat.jpeg,
          keepExif: false,
          autoCorrectionAngle: false,
        );
        dimensions = await _dimensions(output);
      }
      if (math.max(dimensions.$1, dimensions.$2) > 1600) {
        throw const FileSystemException('Could not resize photo');
      }
      final result = StoredPhoto(relative, dimensions.$1, dimensions.$2);
      await File(staging).writeAsBytes(output, flush: true);
      await File(staging).rename(target);
      return result;
    } catch (_) {
      for (final path in [staging, target]) {
        final file = File(path);
        if (await file.exists()) await file.delete();
      }
      rethrow;
    }
  }

  Future<(int, int)> _dimensions(Uint8List bytes) async {
    final codec = await ui.instantiateImageCodec(bytes);
    try {
      final frame = await codec.getNextFrame();
      try {
        return (frame.image.width, frame.image.height);
      } finally {
        frame.image.dispose();
      }
    } finally {
      codec.dispose();
    }
  }

  @override
  Future<void> remove(String relativePath) async {
    final file = File(absolutePath(relativePath));
    if (await file.exists()) await file.delete();
  }

  @override
  Future<void> cleanOrphans(Set<String> referencedPaths) async {
    final folder = Directory(p.join(root.path, 'photos'));
    if (!await folder.exists()) return;
    await for (final entity in folder.list()) {
      if (entity is File &&
          !referencedPaths.contains(p.relative(entity.path, from: root.path))) {
        await entity.delete();
      }
    }
  }
}
