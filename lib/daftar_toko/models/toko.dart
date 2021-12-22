import 'package:flutter/material.dart';

class Tokos {
  String namaPerusahaan="";
  String namaToko="";
  
  Tokos({
    this.namaPerusahaan="",
    this.namaToko="",
  });
}

class Toko {
  String model;
  int pk;
  String namaPerusahaan;
  String namaToko;
  Image img;

  Toko({required this.model, required this.pk, required this.namaPerusahaan, required this.namaToko});

  factory Toko.fromJson(Map<String, dynamic> json) {
    return Toko(
        model: json['model'],
        pk: json['pk'],
        company_search : json['company_search'] != null ? new Fields.fromJson(json['fields']) : null,
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['model'] = this.model;
    data['pk'] = this.pk;
    if (this.fields != null) {
      data['fields'] = this.fields?.toJson();
    }
    return data;
  }
}