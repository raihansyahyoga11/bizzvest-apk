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
  String full_name;
  String phone_number ;
  String gender;
  String username;
  String email;
  String deskripsi_diri;
  String alamat;
  // String photo_profile; 


UserForm({
  this.csrf_token="",
  this.full_name="",
  this.phone_number="",
  this.gender="",
  this.username="",
  this.email="",
  this.deskripsi_diri="",
  this.alamat="",
  // this.photo_profile= "aenjeaye",
});


Map<String,dynamic> to_map() {
  return {
    'csrf_token': this.csrf_token,
    'full_name': this.full_name,
    'phone_number': this.phone_number,
    'gender': this.gender,
    'username': this.username,
    'email': this.email,
    'deskripsi_diri': this.deskripsi_diri,
    'alamat': this.alamat,
    // 'photo_profile': this.photo_profile
  };
}
}

class UserFormErrors{
  String? csrf_token;
  String? full_name;
  String? phone_number ;
  String? gender;
  String? username;
  String? email;
  String? deskripsi_diri;
  String? alamat;

  UserFormErrors({
  this.csrf_token,
  this.full_name,
  this.phone_number,
  this.gender,
  this.username,
  this.email,
  this.deskripsi_diri,
  this.alamat,
  });


  Map<String, String> to_map(){
    return {
      if (this.csrf_token != null)
        'csrf_token': this.csrf_token!,
      if (this.full_name != null)
        'full_name': this.full_name!,
      if (this.phone_number != null)
        'phone_number': this.phone_number!,
      if (this.gender != null)
        'gender': this.gender!,
      if (this.username!= null)
        'username': this.username!,
      if (this.email != null)
        'email': this.email!,
      if (this.deskripsi_diri != null)
        'deskripsi_diri': this.deskripsi_diri!,
      if (this.alamat != null)
        'alamat': this.alamat!,
    };
  }


  static UserFormErrors from_map(Map<String, String> map){
    UserFormErrors ret = UserFormErrors();

    if (map.containsKey('full_name'))
      ret.full_name = map['full_name'];
    if (map.containsKey('csrf_token'))
      ret.csrf_token = map['csrf_token'];
    if (map.containsKey('phone_number'))
      ret.phone_number = map['phone_number'];
    if (map.containsKey('alamat'))
      ret.alamat = map['alamat'];
    if (map.containsKey('gender'))
      ret.gender = map['gender'];
    if (map.containsKey('email'))
      ret.email = map['email'];
    if (map.containsKey('deskripsi_diri'))
      ret.deskripsi_diri = map['deskripsi_diri'];
    if (map.containsKey('username'))
      ret.username = map['username'];

    return ret;
  }
}
