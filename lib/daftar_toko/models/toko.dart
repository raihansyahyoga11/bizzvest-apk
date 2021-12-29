import 'package:flutter/material.dart';

class Toko {
  String namaPerusahaan="";
  String namaToko="";
  String img;

  Toko(
    {
      required this.namaPerusahaan, 
      required this.namaToko, 
      required this.img
    }
  );

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
        namaToko: json['nama_toko'],
        namaPerusahaan: json['nama_perusahaan'],
        img: json['img'],
    );
  }
}
