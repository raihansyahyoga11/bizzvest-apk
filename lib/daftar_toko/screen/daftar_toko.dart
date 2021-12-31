import 'package:flutter/material.dart';

import 'package:bizzvest/daftar_toko/models/toko.dart';
import 'package:bizzvest/daftar_toko/utility/search_toko.dart';
import 'package:bizzvest/daftar_toko/utility/list_daftar_toko.dart';
import 'package:bizzvest/faq/helper/helper.dart';
import 'package:bizzvest/daftar_toko/api/api_daftar_toko.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DaftarTokoMaterial());
}

class DaftarTokoMaterial extends StatelessWidget {
  final String searchText;
  const DaftarTokoMaterial({this.searchText='', Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DaftarToko(searchText: searchText),
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
  final String searchText;
  const DaftarToko({this.searchText='', Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(201, 244, 255, 1),
      body: SingleChildScrollView(
            child: Container(
              color: Color(0xffdafcff),
              margin: const EdgeInsets.all(1.0),
              padding: const EdgeInsets.all(5.0),
              child:  Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: Container(
                          padding: EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Color(0xffc3f1fc),
                              borderRadius: BorderRadius.all(Radius.circular(5.0))),
                          child: new Center (
                              child: Text(
                                "Daftar Toko",
                                style: TextStyle(
                                  fontSize: 25.0,
                                  color: Color(0xff374ABE),
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )
                          )
                      ),
                    ),

                    SizedBox(height: 10.0),
                    SearchForm(),
                    SizedBox(height: 10.0),
                    DaftarTokoListScreen(searchText: searchText),
                    // ListView.builder(
                    //   shrinkWrap: true,
                    //   itemBuilder: (BuildContext context, int index) {
                    //     return new StuffInTiles(listOfTiles[index]);
                    //   },
                    //   itemCount: listOfTiles.length,
                    // ),
                    ],
                  ),
                )
            )
    
    );
  }
}



