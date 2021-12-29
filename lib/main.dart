// @dart=2.9

// import 'package:bizzvest/daftar_toko/main.dart';
// import 'package:bizzvest/faq/faq.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:bizzvest/my_profile/screens/ProfilePage.dart';

void main() {
  // runApp(const MyApp());
  // runApp(const HalamanTokoMaterial());

  runApp(
      MaterialApp(
          home: MyApp()
      )
  );

  /* runApp(
    DevicePreview(
      enabled: false,
      // enabled: !kReleaseMode,
      builder: (context) => const HalamanTokoWrapper(),
    )
  );*/
}
