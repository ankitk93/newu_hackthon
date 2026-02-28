import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/services.dart';

/// Extracts the first animation's JSON bytes from a .lottie (dotLottie) asset.
///
/// The dotlottie_loader package (0.0.5) has a race condition where
/// `Future.forEach` is not awaited, returning an empty animations map.
/// This helper does the extraction synchronously after loading the asset bytes.
Future<Uint8List> loadDotLottieAsset(String assetPath) async {
  final data = await rootBundle.load(assetPath);
  final bytes = data.buffer.asUint8List();
  final archive = ZipDecoder().decodeBytes(bytes);

  for (final file in archive) {
    if (file.name.startsWith('animations/') && file.name.endsWith('.json')) {
      return file.content as Uint8List;
    }
  }

  // Fallback: look for any .json that looks like a Lottie animation
  for (final file in archive) {
    if (file.name.endsWith('.json') && file.name != 'manifest.json') {
      return file.content as Uint8List;
    }
  }

  throw Exception('No animation found in dotLottie asset: $assetPath');
}
