import 'dart:ffi';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/gestures.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import '../screens/EditingPage.dart';
import '../screens/ProfilePage.dart';
import '../api/api_my_profile.dart';
import '../widgets/main_drawer.dart';
import '../models/UserAccount.dart';

import 'package:flutter/cupertino.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class UserForm{
  String csrf_token;
  String nama_lengkap;
  int nomor_telepon ;
  String jenis_kelamin;
  String user_name;
  String e_mail;
  String deskripsi_saya;
  String status_verifikasi;
  String alamat_saya;
  String photo_profile; 


UserForm({
  this.csrf_token="",
  this.nama_lengkap="",
  this.nomor_telepon=0,
  this.jenis_kelamin="",
  this.user_name="",
  this.e_mail="",
  this.deskripsi_saya="",
  this.status_verifikasi="",
  this.alamat_saya="",
  this.photo_profile="" 
});


Map<String,dynamic> to_map() {
  return {
    'csrf_token': this.csrf_token,
    'nama_lengkap': this.nama_lengkap,
    'nomor_telepon': this.nomor_telepon,
    'jenis_kelamin': this.jenis_kelamin,
    'user_name': this.user_name,
    'e_mail': this.e_mail,
    'deskripsi_saya': this.deskripsi_saya,
    'status_verifikasi': this.status_verifikasi,
    'alamat_saya': this.alamat_saya,
    'photo_profile': this.photo_profile
  };
}
}