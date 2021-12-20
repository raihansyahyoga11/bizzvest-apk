
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

bool IS_FLUTTER_DOWNLOADER_INITIALiZED = false;
Future<void> ensure_flutter_downloader_is_initialized() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!IS_FLUTTER_DOWNLOADER_INITIALiZED) {
    IS_FLUTTER_DOWNLOADER_INITIALiZED = true;
    await FlutterDownloader.initialize(debug: true && kDebugMode);
  }
}