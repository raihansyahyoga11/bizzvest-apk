import 'package:flutter/material.dart';

class Toko {
  String namaPerusahaan="";
  String namaToko="";
  Image img;

  Toko({required this.namaPerusahaan, required this.namaToko, required this.img});

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
        namaToko: json['nama_toko'],
        namaPerusahaan: json['nama_perusahaan'],
        img: json['img'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nama_toko'] = this.namaToko;
    data['nama_perusahaan'] = this.namaPerusahaan;
    return data;
  }
}

class Tokos {
  String model;
  int pk;
  Toko? company;

  Tokos({required this.model, required this.pk, required this.company});

  factory Tokos.fromJson(Map<String, dynamic> json) {
    return Tokos(
        model: json['model'],
        pk: json['pk'],
        company : json['company'] != null ? new Toko.fromJson(json['company']) : null,
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['pk'] = this.pk;
    if (this.company != null) {
      data['company'] = this.company?.toJson();
    }
    return data;
  }
}
