import 'package:flutter/material.dart';

import '../widgets/main_drawer.dart';
import '../models/toko.dart';
import '../screen/card_toko.dart';
import 'search_toko.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DaftarTokoMaterial());
}

Future<void> fetchData() async {
    const url = 'http://127.0.0.1:8000/daftar-toko/json';
    try {
      final response = await http.get(Uri.parse(url));
      //print(response.body);
      Map<String, dynamic> extractedData = jsonDecode(response.body);
      extractedData.forEach((key, val) {
        print(val);
      });
    } catch (error) {
      print(error);
    }
  }


List<CustomCard> getTokoWidget(List<Toko> daftarToko){
  List<CustomCard> list = [];
  for(var i=0; i < daftarToko.length; i++){
    list.add(new CustomCard(daftarToko[i].namaToko, daftarToko[i].namaPerusahaan, i+1));
  }
  return list;
}

List<Text> getTokoWidgetText(List<Toko> daftarToko, String str){
  List<Text> list = [];
  for(var i=0; i < daftarToko.length; i++){
    list.add(new Text(daftarToko[i].namaToko+'\n'));
  }
  return list;
}


class DaftarTokoMaterial extends StatelessWidget {
  const DaftarTokoMaterial({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarToko(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData( 
        scaffoldBackgroundColor: const Color.fromRGBO(242, 255, 253, 1),
        primarySwatch: Colors.blue,
        accentColor: Colors.blue,
        canvasColor: Color.fromRGBO(255, 254, 229, 1),
        fontFamily: 'Raleway',
        textTheme: ThemeData.light().textTheme.copyWith(
            bodyText1: TextStyle(
              color: Color.fromRGBO(20, 51, 51, 1),
            ),
            bodyText2: TextStyle(
              color: Color.fromRGBO(48, 158, 158, 1.0),
            ),
            headline6: TextStyle(
              fontSize: 20,
              fontFamily: 'RobotoCondensed',
              fontWeight: FontWeight.bold,
            )),
      ),
    );
  }
}

class DaftarToko extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: MainDrawer(), 
        backgroundColor: const Color.fromRGBO(201, 244, 255, 1),
        // https://www.kindacode.com/article/flutter-add-a-search-field-to-the-app-bar/
        appBar: AppBar(
          // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(5)),
            child: Center(
            // https://www.kindacode.com/article/flutter-add-a-search-field-to-the-app-bar/
              child: MyCustomForm(),
            ), 
          )
          ),
         body: new Container(
              child: new ListView(
                // children: Text("Sementara"),
              ),
            ),
      
    );
  }
}



