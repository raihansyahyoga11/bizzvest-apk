import 'package:flutter/material.dart';

import 'package:bizzvest/daftar_toko/models/toko.dart';
import 'package:bizzvest/daftar_toko/api/api_daftar_toko.dart';
import 'package:bizzvest/halaman_toko/halaman_toko/halaman_toko.dart';
import 'package:bizzvest/halaman_toko/shared/configurations.dart';



class DaftarTokoListScreen extends StatelessWidget {

  final String searchText;
  DaftarTokoListScreen({this.searchText='', Key? key}) : super(key: key);
  late Future<List<Toko>?> futureToko = fetchDaftarToko(searchText) as Future<List<Toko>?>;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: futureToko,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          // return const Center(
          //   child: Text('Tidak dapat memuat daftar toko'),
          // );
          print(Future.error(
                snapshot.error!,
                snapshot.stackTrace));
          //return const Text("Daftar toko tidak dapat dimuat. Silakan refresh atau restart perangkat Anda.");
        } else if (snapshot.hasData) {
          return listDaftarToko(snapshot.data as List<Toko>, context);
        }
        // loading screen
        return const CircularProgressIndicator();
      },
    );
  }

  Widget listDaftarToko(List<Toko> listDaftarToko, BuildContext context)  {
    return Container(
      constraints: const BoxConstraints(
              minHeight: 100, minWidth: 50, maxHeight: 400, maxWidth: double.infinity
      ),
      margin: const EdgeInsets.all(1.0),
      padding: const EdgeInsets.all(1.0),
      child: ListView.builder(
        itemCount: listDaftarToko.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          var toko = listDaftarToko[index];
          return Card(
            child: InkWell(                        
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Column(
                      children: <Widget>[
                        Image.network(NETW_CONST.protocol + NETW_CONST.host + toko.img),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            toko.namaToko, 
                            style: TextStyle(
                              color: Color(0xff374ABE),
                              fontSize: 25.0,
                              fontFamily: 'Trisan',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(7.0),
                          child: Text(
                            toko.namaPerusahaan, 
                            style: TextStyle(fontSize: 20.0),
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
          );
        }
      )
    );
  }
}


