import 'package:flutter/material.dart';

import 'package:bizzvest/daftar_toko/widgets/main_drawer.dart';
import 'package:bizzvest/daftar_toko/models/toko.dart';
import 'package:bizzvest/daftar_toko/utility/search_toko.dart';
import 'package:bizzvest/daftar_toko/utility/list_daftar_toko.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(DaftarTokoMaterial());
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
      backgroundColor: const Color.fromRGBO(201, 244, 255, 1),
      // https://www.kindacode.com/article/flutter-add-a-search-field-to-the-app-bar/
      appBar: AppBar(
        // The search area here
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)
          ),
          child: Column(
            children: <Widget>[
              Text("Daftar Toko"),
              Center(
                // https://www.kindacode.com/article/flutter-add-a-search-field-to-the-app-bar/
                child: SearchForm(),
              ), 
          ],
          ),
        )
      ),
      body: Center(
        child: DaftarTokoListScreen(),
      )
    );
  }
}



