import 'package:bizzvest/daftar_toko/main.dart';
import 'package:bizzvest/halaman_toko/add_toko.dart';
import 'package:bizzvest/halaman_toko/halaman_toko.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  // runApp(const MyApp());
  // runApp(const HalamanTokoMaterial());

  runApp(const HalamanToko(id:8));

 /* runApp(
    DevicePreview(
      enabled: false,
      // enabled: !kReleaseMode,
      builder: (context) => const HalamanTokoWrapper(),
    )
  );*/
}
