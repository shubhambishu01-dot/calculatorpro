import 'dart:typed_data';

import 'base64_file_io.dart'
    if (dart.library.html) 'base64_file_web.dart' as platform;

Future<String> saveDecodedFile(Uint8List bytes, String filename) {
  return platform.saveDecodedFile(bytes, filename);
}

Future<String> writeShareFile(Uint8List bytes, String filename) {
  return platform.writeShareFile(bytes, filename);
}
