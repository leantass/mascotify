import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Flutter no contiene claves hardcodeadas de proveedores de clips', () {
    final libDir = Directory('lib');
    final dartFiles = libDir
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
    final forbiddenPatterns = <RegExp>[
      RegExp(r'PEXELS_API_KEY'),
      RegExp(r'PIXABAY_API_KEY'),
      RegExp(r'Authorization.{0,12}Bearer\s+[A-Za-z0-9_\-.]+'),
      RegExp(r'api\.pexels\.com/videos/search'),
      RegExp(r'pixabay\.com/api/videos'),
    ];

    final matches = <String>[];
    for (final file in dartFiles) {
      final content = file.readAsStringSync();
      for (final pattern in forbiddenPatterns) {
        if (pattern.hasMatch(content)) matches.add(file.path);
      }
    }

    expect(matches, isEmpty);
  });
}
