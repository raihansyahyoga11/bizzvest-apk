import 'package:flutter/material.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';


// processed from https://stackoverflow.com/questions/49819221/flutter-cards-how-to-loop-a-card-widgets-in-flutter
class CardToko extends StatelessWidget {
  int id;
  String namaPerusahaan;
  String namaToko;
  String img;
  
   CardToko(
    {
      required this.id,
      required this.namaToko,
      required this.namaPerusahaan,
      required this.img,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Card(
        child: InkWell(                        
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(7.0),
                child: Column(
                  children: <Widget>[
                    Image.network(img,width:300,height:300),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(namaToko ,style: TextStyle(fontSize: 18.0),
                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Text(namaPerusahaan ,style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                  ],
                )
              )
            ],
          ),                      
          onTap: () {     
            // TODO                     
            Navigator.push(context, MaterialPageRoute(builder: (context) => HalamanTokoMaterialApp(id: id)));
          },                      
        )
        
    );
  }
}