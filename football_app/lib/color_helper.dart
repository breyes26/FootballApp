import 'dart:async';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorHelper {
  static Future<PaletteGenerator> fetchPalette(String url) async {
    PaletteGenerator palletGenerator =
        await PaletteGenerator.fromImageProvider(Image.network(url).image);
    return palletGenerator;
  }

  static Color getFontColorForBackground(Color background) {
    return (background.computeLuminance() > 0.179)
        ? Colors.black
        : Colors.white;
  }
}
