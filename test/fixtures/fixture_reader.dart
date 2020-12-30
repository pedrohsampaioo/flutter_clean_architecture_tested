import 'dart:io';

String fixture(String fileName) =>
    File('${Directory.current.path}/fixtures/$fileName').readAsStringSync();
