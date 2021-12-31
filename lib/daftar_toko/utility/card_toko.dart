import 'package:flutter/material.dart';

import 'package:bizzvest/daftar_toko/models/toko.dart';
import 'package:bizzvest/daftar_toko/api/api_daftar_toko.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';


List<Widget> getListToko(List<Toko> listDaftarToko, BuildContext context)  {
  List<Widget> list = [];
  for(var i=0; i < listDaftarToko.length; i++){
    Toko toko = listDaftarToko[i];
    list.add(Card(
      child: InkWell(                        
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(7.0),
              child: Column(
                children: <Widget>[
                  Image.network(toko.img,width:300,height:300),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(toko.namaToko ,style: TextStyle(fontSize: 18.0),
                  ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(toko.namaPerusahaan ,style: TextStyle(fontSize: 13.0),
                    ),
                  ),
                ],
              )
            )
          ],
        ),                      
        onTap: () {                     
          Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanToko(id: toko.id)));
        },                      
      ),
    )
    );
  }
  return list;
} 
  



