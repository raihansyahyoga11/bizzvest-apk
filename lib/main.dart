import 'package:bizzvest/daftar_toko/main.dart';
import 'package:bizzvest/halaman_toko/add_toko.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';
import 'package:bizzvest/my_profile/screens/ProfilePage.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

void main() {
  // runApp(const MyApp());
  // runApp(const HalamanTokoMaterial());
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App name',
      home:ProfilePage(),
      
    );
  }
  runApp(ProfilePage());

 /* runApp(
    DevicePreview(
      enabled: false,
      // enabled: !kReleaseMode,
      builder: (context) => const HalamanTokoWrapper(),
    )
  );*/
}
