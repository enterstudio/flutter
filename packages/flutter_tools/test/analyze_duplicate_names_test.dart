// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter_tools/src/base/file_system.dart';
import 'package:flutter_tools/src/commands/analyze.dart';
import 'package:path/path.dart' as path;
import 'package:test/test.dart';

import 'src/common.dart';
import 'src/context.dart';
import 'src/mocks.dart';

void main() {
  Directory tempDir;

  setUp(() {
    tempDir = fs.systemTempDirectory.createTempSync('analysis_duplicate_names_test');
  });

  tearDown(() {
    tempDir?.deleteSync(recursive: true);
  });

  group('analyze', () {
    testUsingContext('flutter analyze with two files with the same name', () async {
      File dartFileA = fs.file(path.join(tempDir.path, 'a.dart'));
      dartFileA.parent.createSync();
      dartFileA.writeAsStringSync('library test;');
      File dartFileB = fs.file(path.join(tempDir.path, 'b.dart'));
      dartFileB.writeAsStringSync('library test;');

      AnalyzeCommand command = new AnalyzeCommand();
      applyMocksToCommand(command);
      return createTestCommandRunner(command).run(
        <String>['analyze', '--no-current-package', '--no-current-directory', dartFileA.path, dartFileB.path]
      ).then((_) {
        expect(testLogger.statusText, startsWith('Analyzing 2 files...\nNo analyzer warnings!'));
      });

    });
  });
}
