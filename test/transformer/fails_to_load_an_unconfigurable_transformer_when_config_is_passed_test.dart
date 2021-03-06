// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS d.file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library pub_tests;

import 'package:scheduled_test/scheduled_test.dart';

import '../descriptor.dart' as d;
import '../test_pub.dart';
import '../serve/utils.dart';

main() {
  withBarbackVersions("any", () {
     integration("fails to load an unconfigurable transformer when config is "
         "passed", () {
       d.dir(appPath, [
         d.pubspec({
           "name": "myapp",
           "transformers": [{"myapp/src/transformer": {'foo': 'bar'}}]
         }),
         d.dir("lib", [d.dir("src", [
           d.file("transformer.dart", REWRITE_TRANSFORMER)
         ])])
       ]).create();

       createLockFile('myapp', pkg: ['barback']);

       var pub = startPubServe();
       pub.stderr.expect(startsWith('No transformers that accept configuration '
           'were defined in '));
       pub.shouldExit(1);
     });
  });
}